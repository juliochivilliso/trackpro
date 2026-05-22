export class CreateDriverDto {
  firstName: string;
  lastName: string;
  licenseNumber: string;
  licenseExpiration?: string | Date;
  isActive?: boolean;
}
