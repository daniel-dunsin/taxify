import mongoose from 'mongoose';
import { createSchema } from '../../../utils';
import { User } from '../@types/db';
import { Role } from '../@types/enums';
import { DBCollections } from '../../../utils/constants';

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
  },

  profile_picture_id: {
    type: String,
    select: false,
  },

  role: {
    type: String,
    enum: Object.values(Role),
  },
});

export const userModel = mongoose.model(DBCollections.User, UserSchema);
