export interface EmailDto {
  to: string;
  subject: string;
  template: string;
  context: any;
}

export interface PushDto<
  T extends {
    redirect_url?: string;
  } = {
    redirect_url?: string;
  }
> {
  user_id: string;
  title: string;
  body: string;
  imageUrl?: string;
  data?: T;
}
