/* Runs the testacular server
 * The first arg (argv[2]) is the resolved path to a config file (for Lineman, this is usually empty)
 * The second arg (argv[3]) is a stringified JSON of the test configuration.
 */

require('testacular').server.start(process.argv[2], JSON.parse(process.argv[3]));