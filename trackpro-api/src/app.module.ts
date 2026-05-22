import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { VehiclesModule } from './vehicles/vehicles.module';
import { DriversModule } from './drivers/drivers.module';
import { EquipmentModule } from './equipment/equipment.module';
import { AssignmentsModule } from './assignments/assignments.module';

@Module({
  imports: [
    PrismaModule,
    VehiclesModule,
    DriversModule,
    EquipmentModule,
    AssignmentsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
