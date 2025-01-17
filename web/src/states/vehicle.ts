import { atom, useAtom, useAtomValue, useSetAtom } from "jotai";

export interface VehicleStateInterface {
    speed: number;
    rpm: number;
    engineState: boolean;
    engineHealth: number;
    gears: number;
    fuel: number;
    nos: number;
    speedUnit: "MPH" | "KPH";
}

const mockVehicleState: VehicleStateInterface = {
    speed: 222,
    rpm: 50,
    engineState: true,
    engineHealth: 50,
    gears: 6,
    fuel: 50,
    nos: 40,
    speedUnit: "MPH"
};

const vehicleState = atom<VehicleStateInterface>(mockVehicleState);

export const useVehicleState = () => useAtomValue(vehicleState);
export const useSetVehicleState = () => useSetAtom(vehicleState);
export const useVehicleStateStore = () => useAtom(vehicleState);
