import { IsEmail, IsString, MinLength } from 'class-validator';
// import { UserRole } from "prisma/src/generated/enums"

export class UserLoginDto {
  @IsString()
  @MinLength(6, { message: 'Пароль должен содержать минимум 6 символов' })
  password: string;
  @IsEmail()
  email: string;
}
