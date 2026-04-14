import { IsString, MaxLength, MinLength } from 'class-validator';
import { UserLoginDto } from './userLoginDto';

export class UserRegisterDto extends UserLoginDto {
  @IsString({ message: 'Имя должно быть строкой' })
  @MinLength(2, { message: 'Имя должно содержать минимум 2 символа' })
  @MaxLength(15, { message: 'Имя должно содержать максимум 15 символов' })
  name: string;
}
