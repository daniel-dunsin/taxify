import log4js, { Log4js, Logger as Log4JSLogger } from 'log4js';

class Logger {
  private readonly _logger: Log4JSLogger;

  constructor(service?: string) {
    const instanceConfig = {
      appenders: {
        console: { type: 'console' },
        app: { type: 'file', filename: 'logs/app.log' },
        seeders: { type: 'file', filename: 'logs/seeders.log' },
        mailer: { type: 'file', filename: 'logs/mailer.log' },
        queues: { type: 'file', filename: 'logs/queues.log' },
        payment: { type: 'file', filename: 'logs/payment.log' },
        webhook: { type: 'file', filename: 'logs/webhook.log' },
        others: { type: 'file', filename: 'logs/misc.log' },
      },
      categories: {
        app: { appenders: ['console', 'app'], level: 'debug' },
        seeders: { appenders: ['console', 'seeders'], level: 'debug' },
        mailer: { appenders: ['console', 'mailer'], level: 'debug' },
        queues: { appenders: ['console', 'queues'], level: 'debug' },
        paystackProvider: { appenders: ['console', 'payment'], level: 'debug' },
        webhookService: { appenders: ['console', 'webhook'], level: 'debug' },
        default: { appenders: ['console', 'others'], level: 'debug' },
      },
    };

    log4js.configure(instanceConfig);

    this._logger = log4js.getLogger(service);
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
