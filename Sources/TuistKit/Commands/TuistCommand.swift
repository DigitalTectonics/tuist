import ArgumentParser
import Foundation
import TuistSupport

public struct TuistCommand: AsyncParsableCommand {
    public init() {}

    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "tuist",
            abstract: "Generate, build and test your Xcode projects.",
            subcommands: [
                BuildCommand.self,
                CleanCommand.self,
                DumpCommand.self,
                EditCommand.self,
                FetchCommand.self,
                GenerateCommand.self,
                GraphCommand.self,
                InitCommand.self,
                MigrationCommand.self,
                PluginCommand.self,
                RunCommand.self,
                ScaffoldCommand.self,
                SigningCommand.self,
                TestCommand.self,
                VersionCommand.self,
            ]
        )
    }

    @Flag(
        name: [.customLong("help-env")],
        help: "Display subcommands to manage the environment tuist versions."
    )
    var isTuistEnvHelp: Bool = false

    public static func main(
        _ arguments: [String]? = nil,
        parseAsRoot: ((_ arguments: [String]?) throws -> ParsableCommand) = Self.parseAsRoot
    ) async {
        let errorHandler = ErrorHandler()
        let executeCommand: () async throws -> Void
        let processedArguments = Array(processArguments(arguments)?.dropFirst() ?? [])
        var parsedError: Error?
        do {
            if processedArguments.first == ScaffoldCommand.configuration.commandName {
                try await ScaffoldCommand.preprocess(processedArguments)
            }
            if processedArguments.first == InitCommand.configuration.commandName {
                try InitCommand.preprocess(processedArguments)
            }
            let command = try parseAsRoot(processedArguments)
            executeCommand = {
                try await execute(
                    command: command,
                    commandArguments: processedArguments
                )
            }
        } catch {
            parsedError = error
            executeCommand = {
                try executeTask(with: processedArguments)
            }
        }

        do {
            try await executeCommand()
        } catch let error as FatalError {
            errorHandler.fatal(error: error)
            _exit(exitCode(for: error).rawValue)
        } catch {
            if let parsedError {
                handleParseError(parsedError)
            }
            // Exit cleanly
            if exitCode(for: error).rawValue == 0 {
                exit(withError: error)
            } else {
                errorHandler.fatal(error: UnhandledError(error: error))
                _exit(exitCode(for: error).rawValue)
            }
        }
    }

    private static func executeTask(with processedArguments: [String]) throws {
        try TuistService().run(
            arguments: processedArguments,
            tuistBinaryPath: processArguments()!.first!
        )
    }

    private static func handleParseError(_ error: Error) -> Never {
        let exitCode = exitCode(for: error).rawValue
        if exitCode == 0 {
            logger.info("\(fullMessage(for: error))")
        } else {
            logger.error("\(fullMessage(for: error))")
        }
        _exit(exitCode)
    }

    private static func execute(
        command: ParsableCommand,
        commandArguments _: [String]
    ) async throws {
        var command = command
        if var asyncCommand = command as? AsyncParsableCommand {
            try await asyncCommand.run()
        } else {
            try command.run()
        }
    }

    // MARK: - Helpers

    static func processArguments(_ arguments: [String]? = nil) -> [String]? {
        let arguments = arguments ?? Array(ProcessInfo.processInfo.arguments)
        return arguments.filter { $0 != "--verbose" }
    }
}
