import { EmailDto } from '../modules/v1/@types';
import { Env } from '../utils/constants';
import Logger from './logger';
import { createTransport } from 'nodemailer';

const logger = new Logger('mailer');

const transporter = createTransport({
  service: 'gmail',
  from: 'noreply@taxify.com',
  auth: {
    user: Env.mailer.user,
    pass: Env.mailer.password,
  },
});

transporter?.on('token', () => logger.log('mailer connected successfully'));

transporter?.on('error', () => logger.error('mailer error occured'));

export const sendMail = async (emailDto: EmailDto) => {
  try {
    await transporter.sendMail({
      from: "'No Reply' <noreply@taxify.com>",
      to: emailDto.to,
      subject: emailDto.subject,
    });
    logger.log('Mail sent successfully');
  } catch (error) {
    logger.error(`Unable to send mail ${JSON.stringify(error)}`);
  }
};
