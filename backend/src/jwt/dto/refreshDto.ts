import { Transform } from 'class-transformer';
import { IsString } from 'class-validator';

export class RefreshTokenDto {
  @IsString({ message: 'Токен должен быть строкой' })
  @Transform(({ value }) => value?.trim())
  refreshToken: string;
}
