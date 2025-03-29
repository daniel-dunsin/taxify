import mongoose from 'mongoose';
import { VerificationDocument } from '../../../@types/db';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';
import { VerificationDocuments } from '../../../@types/enums';

const VerificationDocumentSchema = createSchema<VerificationDocument>({
  name: {
    type: String,
    enum: Object.values(VerificationDocuments),
    required: true,
  },
  url: {
    type: String,
  },
  upload_id: {
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

const verificationDocumentModel = mongoose.model(
  DBCollections.VerificationDocument,
  VerificationDocumentSchema
);

export default verificationDocumentModel;
