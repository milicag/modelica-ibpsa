within IBPSA.Fluid.PlugFlowPipes.BaseClasses;
model PipeAdiabaticPlugFlow
  "Pipe model using spatialDistribution for temperature delay without heat losses"
  extends IBPSA.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.SIunits.Length dh
    "Hydraulic diameter (assuming a round cross section area)";

  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Temperature T_start_in=Medium.T_default
    "Initial temperature in pipe at inlet"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.SIunits.Temperature T_start_out=Medium.T_default
    "Initial temperature in pipe at outlet"
    annotation (Dialog(group="Initialization"));

  parameter Modelica.SIunits.MassFlowRate m_flow_start=0
    annotation (Dialog(group="Initialization", enable=initDelay));

  parameter Boolean initDelay=false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(group="Initialization"));

  Fluid.FixedResistances.HydraulicDiameter res(
    redeclare final package Medium = Medium,
    final dh=dh,
    final m_flow_nominal=m_flow_nominal,
    from_dp=from_dp,
    length=length,
    fac=1,
    dp(nominal=2)) "Pressure drop calculation for this pipe"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Sensors.TemperatureTwoPort senTem_delay(
    m_flow_nominal=m_flow_nominal,
    tau=0,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  IBPSA.Fluid.PlugFlowPipes.BaseClasses.PipeLosslessPlugFlow temperatureDelay(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final dh=dh,
    final length=length,
    final allowFlowReversal=allowFlowReversal,
    initialValuesH={h_ini_in,h_ini_out},
    m_flow_start=m_flow_start)
    "Model for temperature wave propagation with spatialDistribution operator"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));


protected
  parameter Modelica.SIunits.SpecificEnthalpy h_ini_in=Medium.specificEnthalpy(
      Medium.setState_pTX(
      T=T_start_in,
      p=Medium.p_default,
      X=Medium.X_default)) "For initialization of spatialDistribution inlet";

  parameter Modelica.SIunits.SpecificEnthalpy h_ini_out=Medium.specificEnthalpy(
       Medium.setState_pTX(
      T=T_start_out,
      p=Medium.p_default,
      X=Medium.X_default)) "For initialization of spatialDistribution outlet";

  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced"));

  parameter Modelica.SIunits.DynamicViscosity mu_default=
      Medium.dynamicViscosity(Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
    annotation (Dialog(group="Advanced"));

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)) "Default specific heat of water";


equation
  connect(port_a, res.port_a)
    annotation (Line(points={{-100,0},{-70,0},{-40,0}}, color={0,127,255}));
  connect(res.port_b, temperatureDelay.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(temperatureDelay.port_b, senTem_delay.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(senTem_delay.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,40},{100,-42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{100,-28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-26,30},{30,-28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187})}),
    Documentation(revisions="<html>
<ul>
<li>July 4, 2016 by Bram van der Heijde:<br/>Introduce <code>pipVol</code>.</li>
<li>May 27, 2016 by Marcus Fuchs:<br/>Introduce <code>use_dh</code> and adjust <code>dp_nominal</code>. </li>
<li>May 19, 2016 by Marcus Fuchs:<br/>Add current issue and link to example in documentation.</li>
<li>April 2, 2016 by Bram van der Heijde:<br/>Add volumes and pipe capacity at inlet and outlet of the pipe.</li>
<li>October 10, 2015 by Marcus Fuchs:<br/>Copy Icon from KUL implementation and rename model. </li>
<li>June 23, 2015 by Marcus Fuchs:<br/>First implementation. </li>
</ul>
</html>", info="<html>
<p>First implementation of an adiabatic pipe using the fixed resistance from IBPSA and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. 
The temperature propagation is handled by the PipeLosslessPlugFlow component.</p>
<p>This component includes water volumes at the in- and outlet to account for the thermal capacity of the pipe walls. 
Logically, each volume should contain half of the pipe&apos;s real water volume. 
However, this leads to an overestimation, probably because only part of the pipe is affected by temperature changes (see Benonysson, 1991). 
The ratio of the pipe to be included in the thermal capacity is to be investigated further. </p>
<h4>References</h4>
<p>Bennonysson, A. (1991). <i>Dynamic Modelling and Operation Optimization of District Heating Systems</i>. 
PhD Thesis, Technical University of Denmark (DTU).</p>
</html>"));
end PipeAdiabaticPlugFlow;
