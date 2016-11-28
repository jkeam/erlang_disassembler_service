const Promise = require('bluebird');
const exec = require('child_process').exec;

class Disassembler {

  constructor(newLogger) {
    this.logger = newLogger;
  }

  run(code, done) {
    return this.disassemble({code})
    .then((obj) => {
      done(obj);
    })
    .catch((obj) => {
      done(obj);
    });
  }

  // disassembles the given source class file
  disassemble(obj) {
    const code = obj.code;
    return new Promise( (resolve, reject) => {
      const cmd = `./app/lib/disassembler.rb '${code}'`;
      exec(cmd, (error, stdout, stderr) => {
        if (stderr) {
          this.logger.error(stderr);
          reject({
            errors: stderr
          });
        } else {
          resolve({
            result: stdout
          });
        }
      });
    });
  }

}

module.exports = Disassembler;
