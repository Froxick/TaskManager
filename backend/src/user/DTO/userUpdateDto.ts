import {
  IsEmail,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';

export class UserUpdateDto {
  @IsOptional()
  @IsString({ message: 'Имя должно быть строкой' })
  @MinLength(2, { message: 'Имя должно содержать минимум 2 символа' })
  @MaxLength(15, { message: 'Имя должно содержать максимум 15 символов' })
  name?: string;
  @IsOptional()
  @IsString()
  @IsEmail()
  email?: string;
}
