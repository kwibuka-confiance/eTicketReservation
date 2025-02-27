import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddCarToDestination extends StatelessWidget {
  final JourneyDestination destination;
  const AddCarToDestination({required this.destination, super.key});

  @override
  Widget build(BuildContext context) {
    JourneyDestinationController destinationController =
        Get.find<JourneyDestinationController>();
    return GetBuilder(
        init: CarController(),
        builder: (CarController carController) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Wrap(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  child: Text(
                    "Add Car to Destination",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                carController.isGettingCars ||
                        destinationController.isAssigningCar
                    ? SizedBox(
                        height: 130.h,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: carController.cars.length,
                        itemBuilder: (context, item) {
                          if (carController.cars.isEmpty) {
                            return const Center(
                              child: Text("No Cars"),
                            );
                          }
                          return Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.drive_eta),
                                        Text(
                                            " ${carController.cars[item].name}"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 15.sp,
                                        ),
                                        Text(
                                            " ${carController.cars[item].color}"),
                                      ],
                                    ),
                                    Text(
                                        "Plate Number: ${carController.cars[item].plateNumber}",
                                        style: TextStyle(fontSize: 10.sp)),
                                  ],
                                ),
                                destinationController.isAssigningCar
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : ElevatedButton(
                                        onPressed: destination.carId ==
                                                carController.cars[item].id
                                            ? () => destinationController
                                                .unAssignCarToDestination(
                                                    destinationId:
                                                        destination.id)
                                            : () {
                                                destinationController
                                                    .assignCarToDestination(
                                                        destinationId:
                                                            destination.id,
                                                        carId: carController
                                                            .cars[item].id);
                                              },
                                        child: destination.carId ==
                                                carController.cars[item].id
                                            ? const Text('Unassign')
                                            : const Text('Assign'),
                                      ),
                              ],
                            ),
                          );
                        }),
              ],
            ),
          );
        });
  }
}

class AssignCarSheet extends StatefulWidget {
  final JourneyDestination destination;

  const AssignCarSheet({
    super.key,
    required this.destination,
  });

  @override
  State<AssignCarSheet> createState() => _AssignCarSheetState();
}

class _AssignCarSheetState extends State<AssignCarSheet> {
  String? selectedCarId;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                Gap(16.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.destination.isAssigned
                                ? "Change Vehicle"
                                : "Assign Vehicle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            "Route: ${widget.destination.description}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search vehicles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Car list
          Expanded(
            child: GetBuilder<CarController>(
              init: CarController(),
              builder: (carController) {
                if (carController.isGettingCars) {
                  return const Center(child: CircularProgressIndicator());
                }

                var availableCars = carController.cars;
                if (_searchQuery.isNotEmpty) {
                  availableCars = availableCars
                      .where((car) =>
                          car.name.toLowerCase().contains(_searchQuery) ||
                          car.plateNumber.toLowerCase().contains(_searchQuery))
                      .toList();
                }

                if (availableCars.isEmpty) {
                  return Center(
                    child: Text(
                      'No vehicles available',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: availableCars.length,
                  itemBuilder: (context, index) {
                    final car = availableCars[index];
                    final isSelected = selectedCarId == car.id;
                    final isCurrentlyAssigned =
                        widget.destination.carId == car.id;

                    return Card(
                      margin: EdgeInsets.only(bottom: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected || isCurrentlyAssigned
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedCarId = isSelected ? null : car.id;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundColor:
                                    isSelected || isCurrentlyAssigned
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade200,
                                child: Icon(
                                  Icons.directions_bus,
                                  color: isSelected || isCurrentlyAssigned
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                              Gap(16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Gap(4.h),
                                    Text(
                                      car.plateNumber,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio<String>(
                                value: car.id,
                                groupValue: selectedCarId,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCarId = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Action buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                if (widget.destination.isAssigned)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final controller =
                            Get.find<JourneyDestinationController>();
                        controller.unAssignCarToDestination(
                          destinationId: widget.destination.id,
                        );
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Remove Vehicle'),
                    ),
                  ),
                if (widget.destination.isAssigned) Gap(16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedCarId == null
                        ? null
                        : () {
                            final controller =
                                Get.find<JourneyDestinationController>();
                            controller.assignCarToDestination(
                              carId: selectedCarId!,
                              destinationId: widget.destination.id,
                            );
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.destination.isAssigned
                          ? 'Change Vehicle'
                          : 'Assign Vehicle',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
