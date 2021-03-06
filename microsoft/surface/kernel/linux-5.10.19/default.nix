{ config, lib, pkgs, ... }:
let
  repos = (pkgs.callPackage ../../repos.nix {});
  patches = repos.linux-surface + "/patches";
  surface_kernelPatches = [
    { name = "microsoft-surface-patches-linux-5.10.19";
      patch = null;
      extraConfig = ''
          #
          # Surface Aggregator Module
          #
          SURFACE_AGGREGATOR m
          SURFACE_AGGREGATOR_ERROR_INJECTION n
          SURFACE_AGGREGATOR_BUS y
          SURFACE_AGGREGATOR_CDEV m
          SURFACE_AGGREGATOR_REGISTRY m

          SURFACE_ACPI_NOTIFY m
          SURFACE_DTX m
          SURFACE_PERFMODE m

          SURFACE_HID m
          SURFACE_KBD m

          BATTERY_SURFACE m
          CHARGER_SURFACE m

          #
          # These built-in modules are required for the Surface Aggregator Module
          # See: https://github.com/linux-surface/surface-aggregator-module/wiki/Testing-and-Installing
          #
          SERIAL_DEV_BUS y
          SERIAL_DEV_CTRL_TTYPORT y

          #
          # Surface Hotplug
          #
          SURFACE_HOTPLUG m

          #
          # IPTS touchscreen
          #
          # This only enables the user interface for IPTS data.
          # For the touchscreen to work, you need to install iptsd.
          #
          MISC_IPTS m

          #
          # Cameras: IPU3
          #
          ## Not yet supported in the patches
          # VIDEO_IPU3_IMGU m
          VIDEO_IPU3_CIO2 m
          CIO2_BRIDGE y
          INTEL_SKL_INT3472 m

          #
          # Cameras: Sensor drivers
          #
          VIDEO_OV5693 m
          ## Not yet supported in the patches
          # VIDEO_OV8865 m

          #
          # ALS Sensor for Surface Book 3, Surface Laptop 3, Surface Pro 7
          #
          APDS9960 m

          #
          # Other Drivers
          #
          INPUT_SOC_BUTTON_ARRAY m
          SURFACE_3_BUTTON m
          SURFACE_3_POWER_OPREGION m
          SURFACE_PRO3_BUTTON m
          SURFACE_GPE m
          SURFACE_BOOK1_DGPU_SWITCH m
        '';
    }
    {
      name = "ms-surface/0001-surface3-oemb";
      patch = patches + "/5.10/0001-surface3-oemb.patch";
    }
    {
      name = "ms-surface/0002-wifi";
      patch = patches + "/5.10/0002-wifi.patch";
    }
    {
      name = "ms-surface/0003-ipts";
      patch = patches + "/5.10/0003-ipts.patch";
    }
    {
      name = "ms-surface/0004-surface-gpe";
      patch = patches + "/5.10/0004-surface-gpe.patch";
    }
    {
      name = "ms-surface/0005-surface-sam-over-hid";
      patch = patches + "/5.10/0005-surface-sam-over-hid.patch";
    }
    {
      name = "ms-surface/0006-surface-sam";
      patch = patches + "/5.10/0006-surface-sam.patch";
    }
    {
      name = "ms-surface/0007-surface-hotplug";
      patch = patches + "/5.10/0007-surface-hotplug.patch";
    }
    {
      name = "ms-surface/0008-surface-typecover";
      patch = patches + "/5.10/0008-surface-typecover.patch";
    }
    {
      name = "ms-surface/0009-surface-sensors";
      patch = patches + "/5.10/0009-surface-sensors.patch";
    }
    {
      name = "ms-surface/0010-cameras";
      patch = patches + "/5.10/0010-cameras.patch";
    }
  ];
in (with pkgs; recurseIntoAttrs (linuxPackagesFor (
     callPackage ./linux-5.10.19.nix {
       kernelPatches = surface_kernelPatches;
     }
   )))
