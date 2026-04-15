import { compare, hash } from 'bcrypt';

export class UserEntity {
  private _password: string;

  constructor(
    private readonly _email: string,
    private readonly _name: string,
    passwordHash?: string,
  ) {
    if (passwordHash) {
      this._password = passwordHash;
    }
  }

  get name() {
    return this._name;
  }
  get email() {
    return this._email;
  }
  get password() {
    return this._password;
  }

  public async setPassword(password: string, salt: number): Promise<void> {
    await hash(password, salt);
  }
  public async validPassword(password: string): Promise<boolean> {
    return await compare(password, this._password);
  }
}
