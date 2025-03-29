import log4js, { Log4js, Logger as Log4JSLogger } from 'log4js';

class Logger {
  private readonly _logger: Log4JSLogger;

  constructor(service: string) {
    this._logger = log4js
      .configure({
        appenders: {
          [service]: { type: 'console' },
          [`${service}-file`]: {
            type: 'file',
            filename: `logs/${service}.log`,
          },
        },
        categories: {
          default: { appenders: [service, `${service}-file`], level: 'debug' },
        },
      })
      .getLogger(service);
  }

  public info(message: string): void {
    this._logger.info(message);
  }

  public error(message: any): void {
    this._logger.error(JSON.stringify(message));
  }

  public log(message: string): void {
    this._logger.log(message);
  }
}

export default Logger;
