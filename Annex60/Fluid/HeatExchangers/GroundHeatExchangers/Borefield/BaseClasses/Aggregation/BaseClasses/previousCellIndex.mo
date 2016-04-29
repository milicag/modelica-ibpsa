within Annex60.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Aggregation.BaseClasses;
function previousCellIndex "Calculates the index [q,p] of the previous cell "
  extends Interface.partialAggFunction;

  input Integer q "Current level number";
  input Integer p "Current cell number";
  output Integer q_pre "Previous level number";
  output Integer p_pre "Previous cell number";

algorithm
  assert((q > 0 and p > 0) and (q > 1 or p > 1),
    "The chosen index is 1. No previous index is possible");
  assert((q <= q_max and p <= p_max),
    "The chosen index is out of the boundaries.");

  if p == 1 then
    q_pre := q - 1;
    p_pre := p_max;
  else
    q_pre := q;
    p_pre := p - 1;
  end if;

    annotation (Documentation(info="<html>
    <p>This function calculates the index [q,p] of the previous cell.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end previousCellIndex;