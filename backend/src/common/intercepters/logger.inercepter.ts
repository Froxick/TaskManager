import {
  CallHandler,
  ExecutionContext,
  Injectable,
  Logger,
  NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggerInterceptor implements NestInterceptor {
  private readonly logger = new Logger('HTTP');

  intercept(
    context: ExecutionContext,
    next: CallHandler<any>,
  ): Observable<any> | Promise<Observable<any>> {
    const now = Date.now();
    const request = context.switchToHttp().getRequest();

    const { method, url } = request;

    this.logger.log(`Incoming request: ${method} ${url}`);

    return next
      .handle()
      .pipe(
        tap(() =>
          this.logger.log(`Response: ${method} ${url} - ${Date.now() - now}ms`),
        ),
      );
  }
}
