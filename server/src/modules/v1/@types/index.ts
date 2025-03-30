export interface EmailDto {
  to: string;
  subject: string;
  template: string;
  context: any;
}
