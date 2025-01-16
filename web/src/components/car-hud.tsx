import React, { useCallback, useMemo } from "react";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import { usePlayerState } from "@/states/player";
import { useVehicleStateStore, type VehicleStateInterface } from "@/states/vehicle";
import { debug } from "@/utils/debug";
import Speedometer from "./ui/speedometer";
import { TextProgressBar } from "./ui/text-progress-bar";
import { FaGasPump} from 'react-icons/fa';  // Import React Icons
import { PiSeatbeltFill } from "react-icons/pi";
import { SiBoosty } from "react-icons/si";
import { PiEngineFill } from "react-icons/pi";

const CarHud = React.memo(function CarHud() {
  const [vehicleState, setVehicleState] = useVehicleStateStore();
  const playerState = usePlayerState();

  const handleVehicleStateUpdate = useCallback(
    (newState: VehicleStateInterface) => {
      setVehicleState((prevState) => {
        if (JSON.stringify(prevState) !== JSON.stringify(newState)) {
          return newState;
        }
        return prevState;
      });
    },
    [setVehicleState],
  );

  useNuiEvent<VehicleStateInterface>("state::vehicle::set", handleVehicleStateUpdate);

  const renderProgressBars = () => {
    return (
      <>
        <TextProgressBar icon={<FaGasPump />} value={vehicleState.fuel} />
        <TextProgressBar icon={<SiBoosty />} value={vehicleState.nos} />
        <TextProgressBar icon={<PiEngineFill />} value={vehicleState.engineState ? 100 : 0} />
        <TextProgressBar icon={<PiSeatbeltFill/>} value={playerState.isSeatbeltOn ? 100 : 0} />
      </>
    );
  };

  const content = useMemo(() => {
    if (!playerState.isInVehicle) {
      debug("(CarHud) Returning with no children since the player is not in a vehicle.");
      return null;
    }

    return (
      <div
        className={"absolute bottom-8 right-16 w-fit h-fit mb-4 flex-col items-center flex justify-center gap-2"}
        style={{
          transform: "perspective(1000px) rotateY(-12deg)",
          backfaceVisibility: "hidden",
          transformStyle: "preserve-3d",
          willChange: "transform",
        }}
      >
        <Speedometer rpm={vehicleState.rpm} speed={vehicleState.speed} gears={vehicleState.gears} engineHealth={vehicleState.engineHealth} maxRpm={100} />
        <div className={"flex gap-2 items-center mr-2 4k:-mt-14"}>
          {renderProgressBars()}
        </div>
      </div>
    );
  }, [playerState.isInVehicle, vehicleState, playerState.isSeatbeltOn]);

  return content;
});

export default CarHud;
