import { asyncHandler } from '../../../utils';
import * as userService from '../services/user.service';

export const getUser = asyncHandler((req, res) =>
  userService.getUser(req.user?._id!)
);
