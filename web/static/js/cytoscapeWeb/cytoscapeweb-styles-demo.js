/*
  This file is part of Cytoscape Web.
  Copyright (c) 2009, The Cytoscape Consortium (www.cytoscape.org)

  The Cytoscape Consortium is:
    - Agilent Technologies
    - Institut Pasteur
    - Institute for Systems Biology
    - Memorial Sloan-Kettering Cancer Center
    - National Center for Integrative Biomedical Informatics
    - Unilever
    - University of California San Diego
    - University of California San Francisco
    - University of Toronto

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
*/

/*
 * Just some visual style samples...
 */
$(function(){
	
	window.GRAPH_STYLES = { };
	
	/*---- DEFAULT -----------------------------------------------------------------------------------*/
	
	GRAPH_STYLES["Default"] = { };
	
	/*---- SIMPLE ------------------------------------------------------------------------------------*/
	
	GRAPH_STYLES["Cytoscape"] = {
			global: {
				backgroundColor: "#ccccff",
				selectionLineColor: "#f6222b",
				selectionLineOpacity: 0.8,
				selectionLineWidth: 1,
				selectionFillOpacity: 0
			},
			nodes: {
				size: 40,
				color: "#ff9999",
				borderColor: "#666666",
				borderWidth: 1.5,
				opacity: 1,
				labelFontSize: 12,
				labelHorizontalAnchor: "center",
				labelGlowOpacity: 0,
				selectionOpacity: 1,
				selectionColor: "#ffff00",
				selectionBorderWidth: 1.5,
				selectionGlowOpacity: 0
			},
			edges: {
				color: "#0000ff",
				width: 1.5,
				mergeWidth: 1.5,
				opacity: 1,
				selectionColor: "#f6222b",
				selectionOpacity: 1,
				selectionGlowOpacity: 0
			}
	};
	
	/*---- CIRCLES -----------------------------------------------------------------------------------*/
	
	var nodeColorMapper = {
			attrName: "source",
			entries: [ { attrValue: "true",  value: "#838fa6" },
			           { attrValue: "false", value: "#fdfdfa" } ]
	};
	var edgeColorMapper = {
			attrName: "network",
			entries: [ { attrValue: "2",  value: "#9e7ba5" },
			           { attrValue: "14", value: "#717cff" },
			           { attrValue: "15", value: "#73c6cd" },
			           { attrValue: "16", value: "#92d17b" },
			           { attrValue: "24", value: "#c67983" },
			           { attrValue: "25", value: "#e4e870" } ]
	};
	
	GRAPH_STYLES["Circles"] = {
			global: {
				backgroundColor: "#ffffff",
				tooltipDelay: 1000
			},
			nodes: {
				shape: "ELLIPSE",
				compoundShape: "ELLIPSE",
				color: { defaultValue: "#fbfbfb", discreteMapper: nodeColorMapper },
				opacity: 1,
				size: { defaultValue: 12, continuousMapper: { attrName: "weight", minValue: 12, maxValue: 36 } },
				borderColor: "#000000",
				tooltipText: "<b>${label}</b> [weight: ${weight}]",
				tooltipFontColor: {
					defaultValue: "#333333",
					discreteMapper: {
						attrName: "source",
						entries: [ { attrValue: "true",  value: "#ffffff" },
						           { attrValue: "false", value: "#333333" } ]
					}
				},
				tooltipBackgroundColor: { defaultValue: "fafafa", discreteMapper: nodeColorMapper },
				labelHorizontalAnchor: "left",
				selectionBorderColor: "#cccc00",
				selectionBorderWidth: 2,
				hoverGlowColor: "#aae6ff",
				hoverGlowOpacity: 0.6,
				labelGlowColor: "#ffffff",
	            labelGlowOpacity: 1,
	            labelGlowBlur: 2,
	            labelGlowStrength: 20
			},
			edges: {
				color: { defaultValue: "#999999", discreteMapper: edgeColorMapper },
				width: { defaultValue: 1, continuousMapper: { attrName: "weight", minValue: 1, maxValue: 4 } },
				mergeWidth: { defaultValue: 1, continuousMapper: { attrName: "weight", minValue: 1, maxValue: 4 } },
				opacity: 1,
				label: { passthroughMapper: { attrName: "id" } },
				labelFontSize: 10,
	            labelFontColor: { defaultValue: "#333333", discreteMapper: edgeColorMapper },
	            labelFontWeight: "bold",
				tooltipText: "<b>weight:</b> ${weight}",
				mergeTooltipText: "<b>weight:</b> ${weight}",
				tooltipFontColor: "#000000",
				tooltipBackgroundColor: { defaultValue: "#fafafa", discreteMapper: edgeColorMapper },
				tooltipBorderColor: { defaultValue: "#fafafa", discreteMapper: edgeColorMapper },
	            labelGlowOpacity: 1,
				curvature: 58
			}
	};
	
	/*---- RECTANGLES --------------------------------------------------------------------------------*/
	
	GRAPH_STYLES["Rectangles"] = {
			global: {
				backgroundColor: "#D6E9F8"
			},
			nodes: {
				shape: "RECTANGLE",
				compoundShape: "RECTANGLE",
				color: "#fefefe",
				borderColor:"#374A70",
				labelFontColor: "#374A70",
				labelHorizontalAnchor: "center",
				labelVerticalAnchor: "bottom",
				labelGlowColor: "#ffffff",
	            labelGlowOpacity: 0,
	            labelGlowBlur: 2,
	            labelGlowStrength: 20,
				selectionGlowOpacity: 0,
				selectionColor: "#ffff00",
				tooltipBackgroundColor: "#ffffff",
				tooltipBorderColor: "#374A70",
				tooltipFontColor: "#374A70"
			},
			edges: {
				color: "#374A70",
				mergeColor: "#ffffff",
				mergeOpacity: { defaultValue: 0.2, continuousMapper: { attrName: "weight", minValue: 0.2, maxValue: 1 } },
				width: 3,
				mergeWidth: 4,
				sourceArrowShape: "circle",
				targetArrowShape: "diamond",
				tooltipBackgroundColor: "#ffffff",
				tooltipBorderColor: "#374A70",
				tooltipFontColor: "#374A70",
				selectionGlowOpacity: 0,
				selectionColor: "#ff0000",
				curvature: 32
			}
	};
	
	/*---- TRIANGLES ---------------------------------------------------------------------------------*/
	
	GRAPH_STYLES["Triangles"] = {
			global: {
				backgroundColor: "#f5f5f5"
			},
			nodes: {
				shape: "TRIANGLE",
				color: "#a5a5a5",
				borderColor: "#999999",
				opacity: 1,
				label: "NODE",
				labelFontName: "_serif",
				labelFontSize: 14,
				labelHorizontalAnchor: "right",
				labelGlowOpacity: 0,
				selectionGlowOpacity: 0,
				selectionColor: "#ff0000",
				hoverBorderWidth: 2,
				hoverBorderColor: "#000000"
			},
			edges: {
				opacity: 1,
				color: { defaultValue: "#999999", discreteMapper: edgeColorMapper },
				width: 2,
				mergeWidth: 2,
				label: { passthroughMapper: { attrName: "weight" } },
				labelFontColor: { defaultValue: "#333333", discreteMapper: edgeColorMapper },
				labelFontSize: 12,
				selectionGlowOpacity: 0,
				selectionColor: "#ff0000"
			}
	};
	
	/*---- DIAMONDS ----------------------------------------------------------------------------------*/
	
	GRAPH_STYLES["Diamonds"] = {
			global: {
				backgroundColor: "#000033"
			},
			nodes: {
				shape: "DIAMOND",
				color: "#6666ee",
				borderColor: "#eeeeff",
				labelFontName: "_typewriter",
				labelFontColor: "#f5f5ff",
				labelFontSize: 14,
				labelHorizontalAnchor: "center",
				labelVerticalAnchor: "top",
				labelGlowOpacity: 0,
				selectionGlowOpacity: 0,
				selectionColor: "#ffce81"
			},
			edges: {
				color: { defaultValue: "#999999", discreteMapper: edgeColorMapper },
				width: 2,
				selectionGlowOpacity: 0,
				selectionColor: "#ffce81"
			}
	};
	
	/*---- GRADIENT ----------------------------------------------------------------------------------*/
	
	GRAPH_STYLES["Gradient"] = {
			nodes: {
				opacity: 1,
				size: { continuousMapper: { attrName: "weight", minValue: 12, maxValue: 60 } },
				color: { continuousMapper: { attrName: "weight", minValue: "#003366", maxValue: "#99ff00" } },
				borderWidth: { defaultValue: 1, continuousMapper: { attrName: "weight", minValue: 1, maxValue: 6 } },
				borderColor: { continuousMapper: { attrName: "weight", minValue: "#99ff00", maxValue: "#003366" } },
				labelFontSize: { continuousMapper: { attrName: "weight", minValue: 11, maxValue: 22 } },
				labelFontColor: { continuousMapper: { attrName: "weight", minValue: "#7777a5", maxValue: "#333355" } },
				labelHorizontalAnchor: {
					defaultValue: "left",
					discreteMapper: {
						attrName: "source",
						entries: [ { attrValue: "true",  value: "right" },
						           { attrValue: "false", value: "left" } ]
					}
				},
				labelGlowOpacity: 0,
				selectionGlowColor: "#ff0000"
			},
			edges: {
				opacity: 1,
				color: { continuousMapper: { attrName: "weight", minValue: "#aaaaaa", maxValue: "#333333" } },
				selectionGlowColor: "#ff0000"
			}
	};
	
	/*---- SHAPES ------------------------------------------------------------------------------------*/
	
	var arrowColors = [ { attrValue: "T",  value: "#33cc33" },
			            { attrValue: "delta", value: "#ff0000" },
			            { attrValue: "diamond", value: "#aaaa00" },
			            { attrValue: "circle", value: "#00ff00" } ];
	var nodeImages = [ { attrValue: "ELLIPSE",  value: "http://cytoscapeweb.cytoscape.org/file/php/proxy.php?mimeType=image/gif&url=http://chart.apis.google.com/chart?chs=300x300%26cht=p%26chd=e0:U-gh..bR" },
	               { attrValue: "OCTAGON", value: "http://cytoscapeweb.cytoscape.org/file/php/proxy.php?mimeType=image/gif&url=http://chart.apis.google.com/chart?chxt=x,y%26chs=300x300%26cht=r%26chco=FF0000%26chd=t:63,64,67,73,77,81,85,86,85,81,74,67,63%26chls=2,4,0%26chm=B,FF000080,0,0,0" },
	               { attrValue: "RECTANGLE", value: "http://cytoscapeweb.cytoscape.org/file/php/proxy.php?mimeType=image/gif&url=http://chart.apis.google.com/chart?chxt=y%26chbh=a%26chs=250x250%26cht=bvs%26chco=A2C180,3D7930%26chds=5,100,-3.333,100%26chd=t:10,50,60,80,40,60,30|50,60,100,40,20,40,30" },
	               { attrValue: "ROUNDRECT", value: "http://cytoscapeweb.cytoscape.org/file/php/proxy.php?mimeType=image/gif&url=http://chart.apis.google.com/chart?chxr=0,0,160%26chxt=x%26chbh=a%26chs=250x250%26cht=bhs%26chco=4D89F9,C6D9FD%26chds=0,160,0,160%26chd=t:10,50,60,80,40,60,30|50,60,100,40,30,40,30" } ];
	
	GRAPH_STYLES["Shapes"] = {
			nodes: {
				color: "#FFBF00",
				compoundShape: "ROUNDRECT",
				size: 32,
				selectionColor: "#ff0000",
				selectionOpacity: 1,
				hoverOpacity: 1,
        		image: {
					discreteMapper:  {
						attrName: "shape",
						entries: nodeImages
					}
				},
				shape: { passthroughMapper: { attrName: "shape" } }
			},
			edges: {
				width: { defaultValue: 1, continuousMapper: { attrName: "weight", minValue: 1, maxValue: 8 } },
				color: "#ced5da",
				style: { defaultValue: "SOLID", passthroughMapper: { attrName: "lineStyle" } },
				mergeWidth: { defaultValue: 2, continuousMapper: { attrName: "weight", minValue: 2, maxValue: 8 } },
				mergeColor: { defaultValue: "#0000ff", continuousMapper: { attrName: "weight", minValue: "#0000ff", maxValue: "#00ff00" } },
				mergeOpacity: 0.6,
				sourceArrowShape: { passthroughMapper: { attrName: "sourceArrowShape" } },
				sourceArrowColor: "#6666ff",
				targetArrowShape: { passthroughMapper: { attrName: "targetArrowShape" } },
				targetArrowColor: {
					defaultValue: null,
					discreteMapper:  {
						attrName: "targetArrowShape",
						entries: arrowColors
					}
				},
				curvature: 36
			}
	};
	
	/*---- NODELESS ----------------------------------------------------------------------------------*/
	
	GRAPH_STYLES["Green Phosphorus"] = {
			global: {
				backgroundColor: "#000000",
				selectionLineColor: "#00aa00",
				selectionFillColor: "#006600"
			},
			nodes: {
				size: 1,
				opacity: 1,
				color: "#000000",
				borderColor: "#000000",
				labelFontSize: 12,
				labelFontColor: "#00ff00",
				labelHorizontalAnchor: "center",
				labelVerticalAnchor: "middle",
				labelFontWeight: {
					defaultValue: "normal",
					discreteMapper: {
						attrName: "source",
						entries: [ { attrValue: "true",  value: "bold" },
						           { attrValue: "false", value: "normal" } ]
					}
				},
				labelFontSize: {
					defaultValue: 12,
					discreteMapper: {
					attrName: "source",
					entries: [ { attrValue: "true",  value: 16 },
					           { attrValue: "false", value: 12 } ]
					}
				},
				labelFontName: "_typewriter",
				tooltipBackgroundColor: "#00ff00",
				selectionGlowOpacity: 0.2,
				selectionGlowColor: "#33ff33",
				labelGlowOpacity: 0
			},
			edges: {
				color: "#006600",
				mergeColor: "#006600",
				tooltipBackgroundColor: "#00ff00",
				sourceArrowShape: {
		            defaultValue: "none",
		            discreteMapper: { attrName: "directed",
		                              entries: [ { attrValue: "true",  value: "delta" },
		                                         { attrValue: "false", value: "none" } ]
		            }
		        },
		        targetArrowShape: {
		        	defaultValue: "none",
		        	discreteMapper: { attrName: "directed",
			        	              entries: [ { attrValue: "true",  value: "T" },
			        	                         { attrValue: "false", value: "none" } ]
			        }
		        },
				selectionGlowOpacity: 0.2,
				selectionGlowColor: "#33ff33"
			}
	};
	
	/*---- DARK --------------------------------------------------------------------------------------*/
	
	GRAPH_STYLES["Dark"] = {
			global: {
				backgroundColor: "#000000",
				selectionLineColor: "#ffffff",
				selectionLineOpacity: 0.5,
				selectionLineWidth: 1,
				selectionFillColor: "#fefefe",
				selectionFillOpacity: 0.1
			},
			nodes: {
				opacity: 0.6,
				size: { defaultValue: 12, continuousMapper: { attrName: "weight", minValue: 12, maxValue: 36 } },
				labelFontColor: "#ffffff",
				tooltipFontColor: "#ffffff",
				tooltipBackgroundColor: "#000000",
				tooltipBorderColor: "#999999",
				labelFontStyle: {
					defaultValue: "normal",
					discreteMapper: {
						attrName: "source",
						entries: [ { attrValue: "true",  value: "italic" },
						           { attrValue: "false", value: "normal" } ]
					}
				},
				labelGlowOpacity: 0,
				hoverOpacity: 1,
				selectionOpacity: 1,
				selectionGlowColor: "#ffffaa"
			},
			edges: {
				opacity: 0.6,
				color: { defaultValue: "#999999", discreteMapper: edgeColorMapper },
				width: { defaultValue: 1, continuousMapper: { attrName: "weight", minValue: 1, maxValue: 4 } },
				mergeWidth: { defaultValue: 1, continuousMapper: { attrName: "weight", minValue: 2, maxValue: 6 } },
				labelFontColor: "#ffffff",
				tooltipFontColor: "#ffffff",
				tooltipBackgroundColor: "#000000",
				tooltipBorderColor: "#999999",
				selectionGlowColor: "#ffffaa",
				hoverOpacity: 1,
				selectionOpacity: 1
			}
	};

});