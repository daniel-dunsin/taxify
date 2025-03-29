import mongoose from 'mongoose';
import app from './app';
import { Env } from './utils/constants';
import Logger from './configs/logger';

const logger = new Logger('app');

app.listen(Env.port, () => {
  logger.log(`Server started on port ${Env.port}`);
  Env.validateEnv();
  mongoose
    .connect(Env.databaseUrl)
    .then(() => logger.log('Database connected successfully'))
    .catch((error) => logger.error(error));
});
