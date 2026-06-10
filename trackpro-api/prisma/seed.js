const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');

  // ── Vehicles ─────────────────────────────────────────────────
  const vehiclesData = [
    { plate: 'A123456', make: 'Honda', model: 'Civic', year: 2021, vin: '1HGBH41JXMN109186', isActive: true },
    { plate: 'L987654', make: 'Toyota', model: 'Hilux', year: 2020, vin: 'MR0FR22G200470478', isActive: true },
    { plate: 'L112233', make: 'Nissan', model: 'Frontier', year: 2019, vin: '3N6PD23Y9ZK000471', isActive: true },
    { plate: 'A445566', make: 'Hyundai', model: 'Sonata', year: 2022, vin: '5NPE24AF8FH105887', isActive: true },
    { plate: 'G778899', make: 'Suzuki', model: 'Grand Vitara', year: 2021, vin: 'JS3TD941614100253', isActive: true },
  ];
  for (const v of vehiclesData) {
    await prisma.vehicle.upsert({ where: { plate: v.plate }, update: v, create: v });
  }
  console.log(`  ✓ ${vehiclesData.length} vehicles`);

  // ── Drivers ──────────────────────────────────────────────────
  const driversData = [
    { firstName: 'Carlos', lastName: 'Méndez', licenseNumber: '001-1234567-8', licenseExpiration: new Date('2026-12-15'), isActive: true },
    { firstName: 'María', lastName: 'Santos', licenseNumber: '001-9876543-2', licenseExpiration: new Date('2026-05-20'), isActive: true },
    { firstName: 'José', lastName: 'Rodríguez', licenseNumber: '001-5555555-5', licenseExpiration: new Date('2025-11-30'), isActive: true },
    { firstName: 'Ana', lastName: 'Guzmán', licenseNumber: '001-7777777-7', licenseExpiration: new Date('2027-08-10'), isActive: true },
    { firstName: 'Pedro', lastName: 'Fernández', licenseNumber: '001-3333333-3', licenseExpiration: new Date('2026-04-01'), isActive: true },
    { firstName: 'Luisa', lastName: 'Pérez', licenseNumber: '001-4444444-4', licenseExpiration: new Date('2028-01-20'), isActive: true },
  ];
  for (const d of driversData) {
    await prisma.driver.upsert({ where: { licenseNumber: d.licenseNumber }, update: d, create: d });
  }
  console.log(`  ✓ ${driversData.length} drivers`);

  // ── Equipment ────────────────────────────────────────────────
  const equipmentData = [
    { code: 'GPS-001', name: 'Sinotrap ST-910', imei: '123456789012345', status: 'ASSIGNED' },
    { code: 'GPS-002', name: 'Queclink GV300', imei: '987654321098765', status: 'ASSIGNED' },
    { code: 'GPS-003', name: 'Coban TK103', imei: '111222333444555', status: 'MAINTENANCE' },
    { code: 'GPS-004', name: 'Queclink GL300', imei: '222333444555666', status: 'ASSIGNED' },
    { code: 'GPS-005', name: 'Teltonika FMB920', imei: '333444555666777', status: 'AVAILABLE' },
    { code: 'GPS-006', name: 'Teltonika FMB003', imei: '444555666777888', status: 'AVAILABLE' },
  ];
  for (const e of equipmentData) {
    await prisma.equipment.upsert({ where: { code: e.code }, update: e, create: e });
  }
  console.log(`  ✓ ${equipmentData.length} equipment`);

  // ── Assignments ──────────────────────────────────────────────
  // Clear old assignments before seeding fresh
  await prisma.assignment.deleteMany();

  // Get records by unique fields
  const honda = await prisma.vehicle.findUnique({ where: { plate: 'A123456' } });
  const toyota = await prisma.vehicle.findUnique({ where: { plate: 'L987654' } });
  const nissan = await prisma.vehicle.findUnique({ where: { plate: 'L112233' } });
  const hyundai = await prisma.vehicle.findUnique({ where: { plate: 'A445566' } });
  const suzuki = await prisma.vehicle.findUnique({ where: { plate: 'G778899' } });

  const gps001 = await prisma.equipment.findUnique({ where: { code: 'GPS-001' } });
  const gps002 = await prisma.equipment.findUnique({ where: { code: 'GPS-002' } });
  const gps003 = await prisma.equipment.findUnique({ where: { code: 'GPS-003' } });
  const gps004 = await prisma.equipment.findUnique({ where: { code: 'GPS-004' } });

  const carlos  = await prisma.driver.findUnique({ where: { licenseNumber: '001-1234567-8' } });
  const maria   = await prisma.driver.findUnique({ where: { licenseNumber: '001-9876543-2' } });
  const ana     = await prisma.driver.findUnique({ where: { licenseNumber: '001-7777777-7' } });

  const assignmentsData = [];
  if (honda && gps001 && carlos) assignmentsData.push({
    vehicleId: honda.id, equipmentId: gps001.id, driverId: carlos.id, isActive: true,
  });
  if (toyota && gps002 && maria) assignmentsData.push({
    vehicleId: toyota.id, equipmentId: gps002.id, driverId: maria.id, isActive: true,
  });
  if (nissan && gps003) assignmentsData.push({
    vehicleId: nissan.id, equipmentId: gps003.id, isActive: false,
  });
  if (hyundai && gps004 && ana) assignmentsData.push({
    vehicleId: hyundai.id, equipmentId: gps004.id, driverId: ana.id, isActive: true,
  });

  for (const a of assignmentsData) {
    await prisma.assignment.create({ data: a });
  }
  console.log(`  ✓ ${assignmentsData.length} assignments`);

  console.log('Seeding complete.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
