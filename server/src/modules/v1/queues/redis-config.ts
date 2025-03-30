import { QueueOptions } from 'bull';
import { Env } from '../../../utils/constants';

export const redisConfig: QueueOptions['redis'] = {
  port: Number(Env.redis.port),
  password: Env.redis.password,
  host: Env.redis.host,
  username: Env.redis.username,
};
