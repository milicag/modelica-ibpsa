within IBPSA.Fluid.Sources;
model Boundary_ph
  "Boundary with prescribed pressure, specific enthalpy, composition and trace substances"
  extends IBPSA.Fluid.Sources.BaseClasses.PartialSource_p;
  extends IBPSA.Fluid.Sources.BaseClasses.PartialSource_h;
  extends IBPSA.Fluid.Sources.BaseClasses.PartialSource_Xi_C;

  annotation (defaultComponentName="bou",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          visible=use_p_in,
          points={{-100,80},{-60,80}},
          color={0,0,255}),
        Line(
          visible=use_h_in,
          points={{-100,40},{-92,40}},
          color={0,0,255}),
        Line(
          visible=use_X_in,
          points={{-100,-40},{-92,-40}},
          color={0,0,255}),
        Line(
          visible=use_C_in,
          points={{-100,-80},{-60,-80}},
          color={0,0,255}),
        Text(
          visible=use_p_in,
          extent={{-150,134},{-72,94}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="p"),
        Text(
          visible=use_h_in,
          extent={{-166,34},{-64,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="h"),
        Text(
          visible=use_X_in,
          extent={{-164,4},{-62,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Text(
          visible=use_C_in,
          extent={{-164,-90},{-62,-130}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C")}),
    Documentation(info="<html>
<p>
Defines prescribed values for boundary conditions:
</p>
<ul>
<li> Prescribed boundary pressure.</li>
<li> Prescribed boundary specific enthalpy.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<h4>Typical use and important parameters</h4>
<p>
If <code>use_p_in</code> is false (default option), 
the <code>p</code> parameter is used as boundary pressure, 
and the <code>p_in</code> input connector is disabled; 
if <code>use_p_in</code> is true, then the <code>p</code> 
parameter is ignored, and the value provided by the 
input connector is used instead.
</p>
<p>
The same applies to the specific enthalpy <i>h</i>, composition <i>X<sub>i</sub></i> or <i>X</i> and trace substances <i>C</i>.
</p>
</p>
<h4>Options</h4>
<p>
Instead of using <code>Xi_in</code> (the <i>independent</i> composition fractions),
the advanced tab provides an option for setting all 
composition fractions using <code>X_in</code>.
<code>use_X_in</code> and <code>use_Xi_in</code> cannot be used
at the same time.
</p>
<p>
Parameter <code>verifyInputs</code> can be set to <code>false</code>
to remove a check that verifies the validity of the used specific enthalpy
and pressures.
This removes the corresponding overhead from the model, which is
a substantial part of the overhead of this model.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>
for more information.
</p>
<p>
Note, that boundary specific enthalpy,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Made <code>medium</code> conditional and refactored inputs.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
<li>
April 18, 2017, by Filip Jorissen:<br/>
Changed <code>checkBoundary</code> implementation
such that it is run as an initial equation
when it depends on parameters only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/728\">#728</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end Boundary_ph;
