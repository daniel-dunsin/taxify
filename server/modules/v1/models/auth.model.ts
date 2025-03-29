import mongoose from 'mongoose';
import { Auth } from '../@types/db';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';

const AuthSchema = createSchema<Auth>({
  user: {
    type: String,
    ref: DBCollections.User,
    required: true,
  },

  password: {
    type: String,
  },

  password_history: {
    type: [String],
    default: [],
  },

  email_verified: {
    type: Boolean,
    default: false,
  },

  accessToken: {
    type: String,
  },

  refreshToken: {
    type: String,
  },
});

const authModel = mongoose.model(DBCollections.Auth, AuthSchema);
export default authModel;
