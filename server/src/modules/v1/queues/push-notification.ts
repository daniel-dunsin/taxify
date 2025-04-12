import Queue, { Job } from 'bull';
import Logger from '../../../configs/logger';
import { PushDto } from '../@types';
import { redisConfig } from './redis-config';
import { userModel } from '../models/user.model';
import { HttpError } from '../@types/globals';
import { HttpStatusCode } from '../../../utils/constants';
import firebase from '../../../configs/firebase';

const logger = new Logger('queues');
const queueName = 'push_notification';

const pushQueue = new Queue<PushDto>(queueName, {
  redis: redisConfig,
});

pushQueue.process(async (job, done) => {
  try {
    const { user_id, title, body, data, imageUrl } = job.data;

    const user = await userModel.findById(user_id).select('deviceToken');

    if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');
    if (!user.deviceToken)
      throw new HttpError(
        HttpStatusCode.NotFound,
        'User does not have a device token'
      );

    await firebase.messaging().send({
      token: user?.deviceToken,
      data,
      notification: {
        title,
        body,
        imageUrl,
      },
      android: {
        notification: {
          channelId: 'fcm-channel-id',
        },
      },
    });

    done();
  } catch (error) {
    done(new Error(JSON.stringify(error)));
  }
});

pushQueue.on('active', (job) => {
  logger.log(`${queueName} ${job.id} dispatched, Job: ${JSON.stringify(job)}`);
});

pushQueue.on('failed', (job: Job) => {
  logger.error(`${queueName} ${job.id} failed, Job: ${JSON.stringify(job)}`);
});

pushQueue.on('completed', (job: Job) => {
  logger.log(`${queueName} ${job.id} completed, Job: ${JSON.stringify(job)}`);
});

export default pushQueue;
