import mongoose, { MongooseQueryOrDocumentMiddleware } from 'mongoose';
import { createSchema } from '../../../utils';
import { User } from '../@types/db';
import { Role } from '../@types/enums';
import { DBCollections, Images } from '../../../utils/constants';

const UserSchema = createSchema<User>({
  firstName: {
    type: String,
  },

  lastName: {
    type: String,
  },

  email: {
    type: String,
    unique: true,
  },

  phoneNumber: {
    type: String,
  },

  profile_picture: {
    type: String,
    default: Images.profile_picture,
  },

  profile_picture_id: {
    type: String,
    select: false,
  },

  role: {
    type: String,
    enum: Object.values(Role),
  },

  deviceToken: {
    type: String,
  },
});

const restrictedOperations: MongooseQueryOrDocumentMiddleware[] = [
  'deleteMany',
  'deleteOne',
  'findOneAndDelete',
];

restrictedOperations.forEach((op) =>
  UserSchema.pre(op, function (next) {
    next(new Error('Operation not allowed on this schema'));
  })
);

export const userModel = mongoose.model(DBCollections.User, UserSchema);
