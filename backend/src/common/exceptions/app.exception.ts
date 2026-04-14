import { HttpException, HttpStatus } from '@nestjs/common';

export class AppException extends HttpException {
  constructor(
    message: string,
    status: HttpStatus = HttpStatus.BAD_REQUEST,
    errorCode?: string,
  ) {
    super(
      {
        message,
        errorCode: errorCode || 'APP_ERROR',
        timestamp: new Date().toISOString(),
      },
      status,
    );
  }
}
