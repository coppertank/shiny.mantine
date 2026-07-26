import {
  LineChart, BarChart, AreaChart, PieChart, DonutChart,
  RadarChart, CompositeChart, RadialBarChart, BubbleChart, FunnelChart,
  Sparkline, ScatterChart, Treemap, Heatmap, SankeyChart,
} from '@mantine/charts';
import '@mantine/charts/styles.css';
import { withReactiveProps } from '../shared';

export const components = {
  LineChart: withReactiveProps(LineChart),
  BarChart: withReactiveProps(BarChart),
  AreaChart: withReactiveProps(AreaChart),
  PieChart: withReactiveProps(PieChart),
  DonutChart: withReactiveProps(DonutChart),
  RadarChart: withReactiveProps(RadarChart),
  CompositeChart: withReactiveProps(CompositeChart),
  RadialBarChart: withReactiveProps(RadialBarChart),
  BubbleChart: withReactiveProps(BubbleChart),
  FunnelChart: withReactiveProps(FunnelChart),
  Sparkline: withReactiveProps(Sparkline),
  ScatterChart: withReactiveProps(ScatterChart),
  Treemap: withReactiveProps(Treemap),
  Heatmap: withReactiveProps(Heatmap),
  SankeyChart: withReactiveProps(SankeyChart),
};
