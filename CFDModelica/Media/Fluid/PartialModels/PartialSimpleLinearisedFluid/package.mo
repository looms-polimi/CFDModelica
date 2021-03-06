within CFDModelica.Media.Fluid.PartialModels;
partial package PartialSimpleLinearisedFluid 
  extends Modelica.Media.Interfaces.PartialPureSubstance(
     singleState=true,
     SpecificEnthalpy(start=1.0e5, nominal=5.0e5),
     Density(start=900, nominal=700),
     AbsolutePressure(start=50e5, nominal=10e5),
     Temperature(start=300, nominal=300));
  constant Modelica.SIunits.SpecificHeatCapacity R_gas=0
  "medium specific gas constant";
  constant Modelica.SIunits.MolarMass MM_const=0 "Molar mass";
  constant Modelica.SIunits.SpecificHeatCapacity cp_const
  "Constant specific heat capacity at constant pressure";
  constant Modelica.SIunits.SpecificHeatCapacity cv_const=cp_const
  "Constant specific heat capacity at constant volume";
  constant Modelica.SIunits.Density rho0 "Density";
  constant Modelica.SIunits.Temperature T_min
  "Minimum temperature valid for medium model";
  constant Modelica.SIunits.Temperature T_max
  "Maximum temperature valid for medium model";
  constant Modelica.SIunits.Temperature T0=reference_T "Reference temperature";
  constant Modelica.SIunits.Pressure p0=reference_p "Reference pressure";
  constant Modelica.SIunits.Pressure p_ref=reference_p
  "Absolute pressure reference";
  constant Modelica.SIunits.SpecificEnthalpy h0 = 104929;
  // Modelica.Media.Water.IF97_Utilities.h_pT(p0, T0);
  constant Modelica.SIunits.DynamicViscosity eta_const
  "Constant dynamic viscosity";
  constant Modelica.SIunits.ThermalConductivity lambda_const
  "Constant thermal conductivity";
  constant Modelica.SIunits.Temperature T0lin=reference_T;
  constant Modelica.SIunits.Density d0=rho0 "Density linearization value";
  constant Real ComprCoeff "Air comprimibility coefficient";
  constant Real ThermalExpCoeff "Air thermal expansion coefficient";


  redeclare record extends ThermodynamicState "thermodynamic state"
    Modelica.SIunits.Temperature T "temperature";
    Modelica.SIunits.Pressure p "pressure";
  end ThermodynamicState;


  redeclare function extends density
  "return density of linear compressible water"
  algorithm
   d := d0 + ComprCoeff*(state.p) - ThermalExpCoeff*(state.T-T0lin);
  end density;


  replaceable function specificInternalEnergy_ph
  "Return specific internal energy from p and h"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Pressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "specific enthalpy";
    output Modelica.SIunits.SpecificInternalEnergy u "specific internal energy";
  algorithm
    u := h;
  end specificInternalEnergy_ph;


  replaceable function specificInternalEnergy_pT
  "Return specific internal energy from p and T"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Pressure p "Pressure";
    input Modelica.SIunits.Temperature T "temperature";
    output Modelica.SIunits.SpecificInternalEnergy u "specific internal energy";
  algorithm
    u := cp_const*(T-T0)+h0;
  end specificInternalEnergy_pT;


  redeclare function specificEnthalpy_pTX
  "Return specific enthalpy from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Pressure p "Pressure";
    input Modelica.SIunits.Temperature T "Temperature";
    input Modelica.SIunits.MassFraction X[nX] "Mass fractions";
    output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy at p, T, X";
  algorithm
    h := cp_const*(T-T0)+h0;
  end specificEnthalpy_pTX;


  redeclare function temperature_phX
  "Return temperature from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Pressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.SIunits.MassFraction X[nX] "Mass fractions";
    output Modelica.SIunits.Temperature T "Temperature";
  algorithm
    T := (h-h0)/cp_const + T0;
  end temperature_phX;


  redeclare function temperature_ph "Return temperature from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Pressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    output Modelica.SIunits.Temperature T "Temperature";
  algorithm
    T := (h-h0)/cp_const + T0;
  end temperature_ph;


  redeclare function setState_pTX
  "Return thermodynamic state from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Pressure p "Pressure";
    input Modelica.SIunits.Temperature T "Temperature";
    input Modelica.SIunits.MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state;
  algorithm
    state := ThermodynamicState(p=p,T=T);
  end setState_pTX;


  redeclare function setState_phX
  "Return thermodynamic state from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Pressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.SIunits.MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state;
  algorithm
    state := ThermodynamicState(p=p,T=T0+(h-h0)/cp_const);
  end setState_phX;


  redeclare function extends specificHeatCapacityCp
  "Return specific heat capacity at constant pressure"
  algorithm
    cp := cp_const;
  end specificHeatCapacityCp;


  redeclare function extends specificHeatCapacityCv
  "Return specific heat capacity at constant volume"
  algorithm
    cv := cv_const;
  end specificHeatCapacityCv;


  redeclare function extends dynamicViscosity "Return const dynamic viscosity"
  algorithm
    eta := eta_const;
  end dynamicViscosity;


  redeclare function extends thermalConductivity "Return thermal conductivity"
  algorithm
    lambda := lambda_const;
  end thermalConductivity;

end PartialSimpleLinearisedFluid;
