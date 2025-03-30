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

  email_verified: {
    type: Boolean,
    default: false,
  },

  accessToken: {
    type: String,
  },

  accessTokenExpiresAt: {
    type: Date,
  },
});

const authModel = mongoose.model(DBCollections.Auth, AuthSchema);
export default authModel;
