// import { UserRole } from "prisma/src/generated";

export interface JwtData {
  email: string;
  id: number;
  name: string;
  iat?: number;
  exp?: number;
}
