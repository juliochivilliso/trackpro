import { Injectable, BadRequestException } from '@nestjs/common';
import { CreateAssignmentDto } from './dto/create-assignment.dto';
import { UpdateAssignmentDto } from './dto/update-assignment.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AssignmentsService {
  constructor(private prisma: PrismaService) {}

  async create(createAssignmentDto: CreateAssignmentDto) {
    // 1. Verificar si el equipo está disponible
    const equipment = await this.prisma.equipment.findUnique({
      where: { id: createAssignmentDto.equipmentId },
    });

    if (!equipment || equipment.status !== 'AVAILABLE') {
      throw new BadRequestException('El equipo no está disponible para asignación');
    }

    // 2. Desactivar asignaciones previas del vehículo si existen
    await this.prisma.assignment.updateMany({
      where: {
        vehicleId: createAssignmentDto.vehicleId,
        isActive: true,
      },
      data: {
        isActive: false,
        endDate: new Date(),
      },
    });

    // 3. Crear nueva asignación
    const assignment = await this.prisma.assignment.create({
      data: {
        vehicleId: createAssignmentDto.vehicleId,
        equipmentId: createAssignmentDto.equipmentId,
        driverId: createAssignmentDto.driverId,
      },
    });

    // 4. Actualizar estado del equipo
    await this.prisma.equipment.update({
      where: { id: createAssignmentDto.equipmentId },
      data: { status: 'ASSIGNED' },
    });

    return assignment;
  }

  async createIntegrated(data: {
    vehicle: {
      plate: string;
      make?: string;
      model?: string;
      year?: number;
      vin?: string;
    };
    equipmentId: number;
    driverId?: number;
  }) {
    return this.prisma.$transaction(async (tx) => {
      // 1. Crear o encontrar el vehículo
      const vehicle = await tx.vehicle.upsert({
        where: { plate: data.vehicle.plate },
        update: data.vehicle,
        create: data.vehicle,
      });

      // 2. Verificar equipo
      const equipment = await tx.equipment.findUnique({
        where: { id: data.equipmentId },
      });

      if (!equipment || equipment.status !== 'AVAILABLE') {
        throw new BadRequestException('Equipo no disponible');
      }

      // 3. Desactivar anteriores
      await tx.assignment.updateMany({
        where: { vehicleId: vehicle.id, isActive: true },
        data: { isActive: false, endDate: new Date() },
      });

      // 4. Nueva asignación
      const assignment = await tx.assignment.create({
        data: {
          vehicleId: vehicle.id,
          equipmentId: data.equipmentId,
          driverId: data.driverId,
        },
      });

      // 5. Update equipo
      await tx.equipment.update({
        where: { id: data.equipmentId },
        data: { status: 'ASSIGNED' },
      });

      return {
        assignment,
        vehicle,
      };
    });
  }

  findAll() {
    return this.prisma.assignment.findMany({
      include: {
        vehicle: true,
        equipment: true,
        driver: true,
      },
    });
  }

  findOne(id: number) {
    return this.prisma.assignment.findUnique({
      where: { id },
      include: {
        vehicle: true,
        equipment: true,
        driver: true,
      },
    });
  }

  update(id: number, updateAssignmentDto: UpdateAssignmentDto) {
    return this.prisma.assignment.update({
      where: { id },
      data: updateAssignmentDto,
    });
  }

  async remove(id: number) {
    const assignment = await this.prisma.assignment.update({
      where: { id },
      data: {
        isActive: false,
        endDate: new Date(),
      },
    });

    // Liberar el equipo
    await this.prisma.equipment.update({
      where: { id: assignment.equipmentId },
      data: { status: 'AVAILABLE' },
    });

    return assignment;
  }
}
