import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { errorHandler } from './utils';
import { HttpError } from './modules/v1/@types/globals';
import router from './modules/v1';
import { HttpStatusCode } from './utils/constants';

const app = express();

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.disable('x-powered-by');

app.use(
  cors({
    origin: '*',
    credentials: true,
  })
);
app.use(helmet());

const limiter = rateLimit({
  windowMs: 1000 * 60 * 60 * 1, // 1 hour
  limit: 1000,
  message: 'Too many request, try again later',
});

app.use(limiter);

app.use('/api/v1', router);

app.all('*', (req, res, next) => {
  return next(
    new HttpError(HttpStatusCode.NotFound, 'Requested resource not found')
  );
});

app.use(errorHandler);

export default app;
