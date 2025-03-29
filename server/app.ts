import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { errorHandler } from './utils';
import { HttpError } from './@types/globals';
import router from './modules/v1/routes';
import { HttpStatusCode } from './utils/constants';

const app = express();

app.use(express.json({ limit: '30kb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.set('trust proxy', true);
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
