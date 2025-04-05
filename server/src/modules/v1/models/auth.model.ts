import mongoose, { MongooseQueryOrDocumentMiddleware } from 'mongoose';
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

const restrictedOperations: MongooseQueryOrDocumentMiddleware[] = [
  'deleteMany',
  'deleteOne',
  'findOneAndDelete',
];

restrictedOperations.forEach((op) =>
  AuthSchema.pre(op, function (next) {
    next(new Error('Operation not allowed on this schema'));
  })
);

const authModel = mongoose.model(DBCollections.Auth, AuthSchema);
export default authModel;
