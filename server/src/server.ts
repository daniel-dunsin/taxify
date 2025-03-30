import mongoose from 'mongoose';
import app from './app';
import { Env } from './utils/constants';
import Logger from './configs/logger';
import runSeeds from './modules/v1/seeders';

const logger = new Logger('app');

app.listen(Env.port, () => {
  logger.log(`Server started on port ${Env.port}`);
  Env.validateEnv();
  mongoose
    .connect(Env.databaseUrl)
    .then(() => (logger.log('Database connected successfully'), runSeeds()))
    .catch((error) => logger.error(error));
});
