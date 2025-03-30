import mongoose from 'mongoose';
import { Token } from '../@types/db';
import { TokenType } from '../@types/enums';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';

const TokenSchema = createSchema<Token>({
  identifier: {
    type: String,
    required: true,
  },
  value: {
    type: String,
    required: true,
  },
  expires_at: {
    type: Date,
    required: false,
  },
  token_type: {
    type: String,
    enum: Object.values(TokenType),
  },
});

export const tokenModel = mongoose.model(DBCollections.Token, TokenSchema);
