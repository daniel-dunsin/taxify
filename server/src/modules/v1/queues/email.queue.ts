import Queue, { Job } from 'bull';
import { redisConfig } from './redis-config';
import { EmailDto } from '../@types';
import { sendMail } from '../../../configs/mailer';
import Logger from '../../../configs/logger';

const logger = new Logger('queues');
const queueName = 'emailQueue';

export const emailQueue = new Queue<EmailDto>(queueName, {
  redis: redisConfig,
});

emailQueue.process(async (job: Job<EmailDto>, done) => {
  try {
    await sendMail(job.data);

    done();
  } catch (error) {
    done(new Error(JSON.stringify(error)));
  }
});

emailQueue.on('active', (job) => {
  logger.log(`${queueName} ${job.id} dispatched, Job: ${JSON.stringify(job)}`);
});

emailQueue.on('failed', (job: Job) => {
  logger.error(`${queueName} ${job.id} failed, Job: ${JSON.stringify(job)}`);
});

emailQueue.on('completed', (job: Job) => {
  logger.log(`${queueName} ${job.id} completed, Job: ${JSON.stringify(job)}`);
});
