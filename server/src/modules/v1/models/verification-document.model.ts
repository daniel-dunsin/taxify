import mongoose, { MongooseQueryOrDocumentMiddleware } from 'mongoose';
import { VerificationDocument } from '../@types/db';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';
import { VerificationDocuments } from '../@types/enums';

const VerificationDocumentSchema = createSchema<VerificationDocument>({
  name: {
    type: String,
    enum: Object.values(VerificationDocuments),
    required: true,
  },
  front_image_id: {
    type: String,
  },
  front_image_url: {
    type: String,
  },
  back_image_id: {
    type: String,
  },
  back_image_url: {
    type: String,
  },
  text: {
    type: String,
  },
  driver: {
    type: String,
    ref: DBCollections.Driver,
  },
  vehicle: {
    type: String,
    ref: DBCollections.Vehicle,
  },
  is_approved: {
    type: Boolean,
    default: false,
  },
});

const restrictedOperations: MongooseQueryOrDocumentMiddleware[] = [
  'deleteMany',
  'deleteOne',
  'findOneAndDelete',
];

restrictedOperations.forEach((op) =>
  VerificationDocumentSchema.pre(op, function (next) {
    next(new Error('Operation not allowed on this schema'));
  })
);

const verificationDocumentModel = mongoose.model(
  DBCollections.VerificationDocument,
  VerificationDocumentSchema
);

export default verificationDocumentModel;
