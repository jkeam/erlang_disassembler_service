const { writeFile } = require('fs');
const {
  mkdirs,
  outputFile,
  remove
} = require('fs-extra');

const { execFile } = require('child_process');
const { v4: uuidv4 } = require('uuid');

class Disassembler {
  constructor(options={logger, guid}) {
    this.logger = options.logger;
    this.guid = options.guid;
  }

  run(code, done) {
    return this.createFile(code)
      .then(this.disassemble)
      .then(done)
      .catch(done);
  }

  createFile(code) {
    const filename = this.generateBaseFilename();
    return new Promise((resolve, reject) => {
      writeFile(`${filename}.erl`, code, 'utf8', (err) => {
        if (err) {
          return reject({ error: err });
        }
        resolve({ filename, code });
      });
    });
  }

  generateBaseFilename() {
    const uuid = uuidv4().replace(/-/, '');
    return `tmp/${uuid}`;
  }

  // disassembles the given source class file
  disassemble({ filename, code }) {
    return new Promise((resolve, reject) => (
      execFile('escript', ['./app/lib/disassembler.erl', filename], {shell: true}, (error, stdout, stderr) => {
        if (stderr) {
          this.logger.error(`Error[${this.guid}]: ${stderr}`);
          return reject({ error: stderr });
        }
        resolve({ result: stdout });
      })
    ));
  }

  // currently unused, not sure if needed
  codeFormatter(code) {
    return code.replace(/\\n/g, `
  `);
  }
}

module.exports = Disassembler;
