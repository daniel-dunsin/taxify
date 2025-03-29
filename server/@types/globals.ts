import { HttpStatusCode } from '../utils/constants';

export class HttpError extends Error {
  statusCode: HttpStatusCode;
  message: string;
  name: string;
  stackTrace?: string;

  constructor(statusCode: HttpStatusCode, message: string, name?: string) {
    super(message);

    this.statusCode = statusCode;
    this.message = message;
    this.name =
      name ||
      Object.entries(HttpStatusCode).find(
        ([key, value]) => value === statusCode
      )?.[0] ||
      'UnknownError';
    this.stackTrace = this.stack;
  }
}
