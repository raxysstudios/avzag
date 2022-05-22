Map<String, dynamic> monodarkThemeData() {
  return <String, dynamic>{
    "version": 8,
    "name": "Dark",
    "metadata": {
      "mapbox:type": "default",
      "mapbox:origin": "monochrome-dark-v1",
      "mapbox:sdk-support": {
        "android": "10.0.0",
        "ios": "10.0.0",
        "js": "2.6.0"
      },
      "mapbox:autocomposite": true,
      "mapbox:groups": {
        "Transit, transit-labels": {
          "name": "Transit, transit-labels",
          "collapsed": true
        },
        "Administrative boundaries, admin": {
          "name": "Administrative boundaries, admin",
          "collapsed": true
        },
        "Transit, bridges": {"name": "Transit, bridges", "collapsed": true},
        "Transit, surface": {"name": "Transit, surface", "collapsed": true},
        "Road network, bridges": {
          "name": "Road network, bridges",
          "collapsed": true
        },
        "Land, water, & sky, water": {
          "name": "Land, water, & sky, water",
          "collapsed": true
        },
        "Road network, tunnels": {
          "name": "Road network, tunnels",
          "collapsed": true
        },
        "Road network, road-labels": {
          "name": "Road network, road-labels",
          "collapsed": true
        },
        "Buildings, built": {"name": "Buildings, built", "collapsed": true},
        "Natural features, natural-labels": {
          "name": "Natural features, natural-labels",
          "collapsed": true
        },
        "Road network, surface": {
          "name": "Road network, surface",
          "collapsed": true
        },
        "Land, water, & sky, built": {
          "name": "Land, water, & sky, built",
          "collapsed": true
        },
        "Place labels, place-labels": {
          "name": "Place labels, place-labels",
          "collapsed": true
        },
        "Point of interest labels, poi-labels": {
          "name": "Point of interest labels, poi-labels",
          "collapsed": true
        },
        "Road network, tunnels-case": {
          "name": "Road network, tunnels-case",
          "collapsed": true
        },
        "Transit, built": {"name": "Transit, built", "collapsed": true},
        "Road network, surface-icons": {
          "name": "Road network, surface-icons",
          "collapsed": true
        },
        "Land, water, & sky, land": {
          "name": "Land, water, & sky, land",
          "collapsed": true
        }
      },
      "mapbox:uiParadigm": "components",
      "mapbox:trackposition": true,
      "mapbox:decompiler": {
        "id": "cl3hf82ox003315qg72h9wx5y",
        "componentVersion": "11.2.0",
        "strata": [
          {
            "id": "monochrome-dark-v1",
            "order": [
              ["land-and-water", "land"],
              ["land-and-water", "water"],
              ["land-and-water", "built"],
              ["transit", "built"],
              ["buildings", "built"],
              ["road-network", "tunnels-case"],
              ["road-network", "tunnels"],
              ["transit", "ferries"],
              ["road-network", "surface"],
              ["transit", "surface"],
              ["road-network", "surface-icons"],
              ["road-network", "bridges"],
              ["transit", "bridges"],
              ["road-network", "traffic-and-closures"],
              ["buildings", "extruded"],
              ["transit", "elevated"],
              ["admin-boundaries", "admin"],
              ["buildings", "building-labels"],
              ["road-network", "road-labels"],
              ["transit", "ferry-aerialway-labels"],
              ["natural-features", "natural-labels"],
              ["point-of-interest-labels", "poi-labels"],
              ["transit", "transit-labels"],
              ["place-labels", "place-labels"],
              ["land-and-water", "sky"]
            ]
          }
        ],
        "components": {
          "land-and-water": "11.2.0",
          "buildings": "11.1.1",
          "road-network": "11.2.0",
          "admin-boundaries": "11.1.1",
          "natural-features": "11.1.1",
          "point-of-interest-labels": "11.1.1",
          "transit": "11.1.1",
          "place-labels": "11.1.1"
        },
        "propConfig": {
          "land-and-water": {
            "colorBase": "#3b3b3b",
            "landType": "Landuse & landcover",
            "transitionLandOnZoom": false,
            "waterStyle": "Shadow",
            "sky": false,
            "land": "Detailed",
            "landStyle": "Outdoors"
          },
          "buildings": {"colorBase": "#3b3b3b", "houseNumbers": false},
          "road-network": {
            "shields": false,
            "roadNetwork": "Simple",
            "iconColorScheme": "Monochrome",
            "oneWayArrows": false,
            "fadeOutRoadsOnZoom": false,
            "colorBase": "#3b3b3b",
            "railwayCrossings": false,
            "exits": false,
            "polygonFeatures": false,
            "turningCircles": false,
            "labels": false
          },
          "admin-boundaries": {
            "admin0Disputed": true,
            "admin0": true,
            "admin1": true,
            "admin2": false,
            "admin1Width": 1,
            "colorBase": "#3b3b3b",
            "admin2DashPattern": "Dash",
            "admin1DashPattern": "Dot dash",
            "admin0DashPattern": "Long dash",
            "admin0DisputedDashPattern": "Dash"
          },
          "natural-features": {
            "colorBase": "#3b3b3b",
            "labelStyle": "Text only",
            "density": 1
          },
          "point-of-interest-labels": {
            "colorBase": "#3b3b3b",
            "labelStyle": "Text only",
            "density": 1,
            "controlDensityByClass": false
          },
          "transit": {
            "aeroways": false,
            "airportLabels": false,
            "aerialways": false,
            "iconColorScheme": "Monochrome",
            "transitLabels": false,
            "colorBase": "#3b3b3b",
            "railwayStyle": false,
            "railways": false,
            "ferries": false,
            "labelStyle": "Text only"
          },
          "place-labels": {
            "colorBase": "#3b3b3b",
            "settlementSubdivisions": false,
            "settlements": true,
            "states": false,
            "countries": false,
            "settlementLabelStyle": "Text only",
            "settlementsDensity": 2
          }
        }
      }
    },
    "center": [43.59000023851877, 43.27896909483644],
    "zoom": 5.8976346461121505,
    "bearing": 0,
    "pitch": 0,
    "sources": {
      "composite": {
        "url": "mapbox://mapbox.mapbox-terrain-v2,mapbox.mapbox-streets-v8",
        "type": "vector"
      }
    },
    "sprite":
        "mapbox://sprites/raxysstudios/cl3hf82ox003315qg72h9wx5y/e0ziozhrx0w3dnkzs5ji1d5fs",
    "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
    "layers": [
      {
        "id": "land",
        "type": "background",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, land"
        },
        "layout": {},
        "paint": {"background-color": "rgb(47, 47, 47)"}
      },
      {
        "id": "landcover-outdoors",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, land"
        },
        "source": "composite",
        "source-layer": "landcover",
        "maxzoom": 12,
        "layout": {},
        "paint": {
          "fill-color": "rgb(47, 47, 47)",
          "fill-opacity": [
            "interpolate",
            ["exponential", 1.5],
            ["zoom"],
            2,
            0.3,
            12,
            0
          ],
          "fill-antialias": false
        }
      },
      {
        "id": "national-park",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, land"
        },
        "source": "composite",
        "source-layer": "landuse_overlay",
        "minzoom": 5,
        "filter": [
          "==",
          ["get", "class"],
          "national_park"
        ],
        "layout": {},
        "paint": {
          "fill-color": "rgb(45, 43, 43)",
          "fill-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            5,
            0,
            6,
            0.75,
            10,
            0.35
          ]
        }
      },
      {
        "id": "national-park_tint-band",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, land"
        },
        "source": "composite",
        "source-layer": "landuse_overlay",
        "minzoom": 9,
        "filter": [
          "==",
          ["get", "class"],
          "national_park"
        ],
        "layout": {"line-cap": "round"},
        "paint": {
          "line-color": "rgb(42, 42, 42)",
          "line-width": [
            "interpolate",
            ["exponential", 1.4],
            ["zoom"],
            9,
            1,
            14,
            8
          ],
          "line-offset": [
            "interpolate",
            ["exponential", 1.4],
            ["zoom"],
            9,
            0,
            14,
            -2.5
          ],
          "line-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            9,
            0,
            10,
            0.75
          ],
          "line-blur": 3
        }
      },
      {
        "id": "landuse",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, land"
        },
        "source": "composite",
        "source-layer": "landuse",
        "minzoom": 5,
        "filter": [
          "match",
          ["get", "class"],
          ["park", "airport", "glacier", "pitch", "sand", "facility"],
          true,
          ["agriculture", "wood", "grass", "scrub"],
          true,
          false
        ],
        "layout": {},
        "paint": {
          "fill-color": "rgb(45, 43, 43)",
          "fill-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            5,
            0,
            6,
            [
              "match",
              ["get", "class"],
              ["agriculture", "wood", "grass", "scrub"],
              0,
              "glacier",
              0.5,
              1
            ],
            15,
            [
              "match",
              ["get", "class"],
              ["wood", "glacier"],
              0.5,
              ["scrub", "grass"],
              0.2,
              1
            ]
          ]
        }
      },
      {
        "id": "waterway-shadow",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, water"
        },
        "source": "composite",
        "source-layer": "waterway",
        "minzoom": 8,
        "layout": {
          "line-cap": [
            "step",
            ["zoom"],
            "butt",
            11,
            "round"
          ],
          "line-join": "round"
        },
        "paint": {
          "line-color": "rgb(11, 11, 11)",
          "line-width": [
            "interpolate",
            ["exponential", 1.3],
            ["zoom"],
            9,
            [
              "match",
              ["get", "class"],
              ["canal", "river"],
              0.1,
              0
            ],
            20,
            [
              "match",
              ["get", "class"],
              ["canal", "river"],
              8,
              3
            ]
          ],
          "line-translate": [
            "interpolate",
            ["exponential", 1.2],
            ["zoom"],
            7,
            [
              "literal",
              [0, 0]
            ],
            16,
            [
              "literal",
              [-1, -1]
            ]
          ],
          "line-translate-anchor": "viewport",
          "line-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            8,
            0,
            8.5,
            1
          ]
        }
      },
      {
        "id": "water-shadow",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, water"
        },
        "source": "composite",
        "source-layer": "water",
        "layout": {},
        "paint": {
          "fill-color": "rgb(11, 11, 11)",
          "fill-translate": [
            "interpolate",
            ["exponential", 1.2],
            ["zoom"],
            7,
            [
              "literal",
              [0, 0]
            ],
            16,
            [
              "literal",
              [-1, -1]
            ]
          ],
          "fill-translate-anchor": "viewport"
        }
      },
      {
        "id": "waterway",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, water"
        },
        "source": "composite",
        "source-layer": "waterway",
        "minzoom": 8,
        "layout": {
          "line-cap": [
            "step",
            ["zoom"],
            "butt",
            11,
            "round"
          ],
          "line-join": "round"
        },
        "paint": {
          "line-color": "rgb(36, 36, 36)",
          "line-width": [
            "interpolate",
            ["exponential", 1.3],
            ["zoom"],
            9,
            [
              "match",
              ["get", "class"],
              ["canal", "river"],
              0.1,
              0
            ],
            20,
            [
              "match",
              ["get", "class"],
              ["canal", "river"],
              8,
              3
            ]
          ],
          "line-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            8,
            0,
            8.5,
            1
          ]
        }
      },
      {
        "id": "water",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, water"
        },
        "source": "composite",
        "source-layer": "water",
        "layout": {},
        "paint": {"fill-color": "rgb(36, 36, 36)"}
      },
      {
        "id": "wetland",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, water"
        },
        "source": "composite",
        "source-layer": "landuse_overlay",
        "minzoom": 5,
        "filter": [
          "match",
          ["get", "class"],
          ["wetland", "wetland_noveg"],
          true,
          false
        ],
        "paint": {
          "fill-color": "rgb(52, 52, 52)",
          "fill-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            10,
            0.25,
            10.5,
            0.15
          ]
        }
      },
      {
        "id": "wetland-pattern",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, water"
        },
        "source": "composite",
        "source-layer": "landuse_overlay",
        "minzoom": 5,
        "filter": [
          "match",
          ["get", "class"],
          ["wetland", "wetland_noveg"],
          true,
          false
        ],
        "paint": {
          "fill-color": "rgb(52, 52, 52)",
          "fill-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            10,
            0,
            10.5,
            1
          ],
          "fill-pattern": "wetland",
          "fill-translate-anchor": "viewport"
        }
      },
      {
        "id": "land-structure-polygon",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, built"
        },
        "source": "composite",
        "source-layer": "structure",
        "minzoom": 13,
        "filter": [
          "all",
          [
            "==",
            ["geometry-type"],
            "Polygon"
          ],
          [
            "==",
            ["get", "class"],
            "land"
          ]
        ],
        "layout": {},
        "paint": {"fill-color": "rgb(47, 47, 47)"}
      },
      {
        "id": "land-structure-line",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "land-and-water",
          "mapbox:group": "Land, water, & sky, built"
        },
        "source": "composite",
        "source-layer": "structure",
        "minzoom": 13,
        "filter": [
          "all",
          [
            "==",
            ["geometry-type"],
            "LineString"
          ],
          [
            "==",
            ["get", "class"],
            "land"
          ]
        ],
        "layout": {"line-cap": "round"},
        "paint": {
          "line-width": [
            "interpolate",
            ["exponential", 1.99],
            ["zoom"],
            14,
            0.75,
            20,
            40
          ],
          "line-color": "rgb(47, 47, 47)"
        }
      },
      {
        "id": "building-outline",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "buildings",
          "mapbox:group": "Buildings, built"
        },
        "source": "composite",
        "source-layer": "building",
        "minzoom": 15,
        "filter": [
          "all",
          [
            "!=",
            ["get", "type"],
            "building:part"
          ],
          [
            "==",
            ["get", "underground"],
            "false"
          ]
        ],
        "layout": {},
        "paint": {
          "line-color": "rgb(36, 36, 36)",
          "line-width": [
            "interpolate",
            ["exponential", 1.5],
            ["zoom"],
            15,
            0.75,
            20,
            3
          ],
          "line-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            15,
            0,
            16,
            1
          ]
        }
      },
      {
        "id": "building",
        "type": "fill",
        "metadata": {
          "mapbox:featureComponent": "buildings",
          "mapbox:group": "Buildings, built"
        },
        "source": "composite",
        "source-layer": "building",
        "minzoom": 15,
        "filter": [
          "all",
          [
            "!=",
            ["get", "type"],
            "building:part"
          ],
          [
            "==",
            ["get", "underground"],
            "false"
          ]
        ],
        "layout": {},
        "paint": {
          "fill-color": [
            "interpolate",
            ["linear"],
            ["zoom"],
            15,
            "rgb(49, 49, 49)",
            16,
            "rgb(42, 42, 42)"
          ],
          "fill-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            15,
            0,
            16,
            1
          ],
          "fill-outline-color": "rgb(36, 36, 36)"
        }
      },
      {
        "id": "tunnel-simple",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "road-network",
          "mapbox:group": "Road network, tunnels"
        },
        "source": "composite",
        "source-layer": "road",
        "minzoom": 13,
        "filter": [
          "all",
          [
            "==",
            ["get", "structure"],
            "tunnel"
          ],
          [
            "step",
            ["zoom"],
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "secondary",
                "tertiary",
                "street",
                "street_limited",
                "primary_link",
                "track"
              ],
              true,
              false
            ],
            14,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "primary_link",
                "secondary",
                "secondary_link",
                "tertiary",
                "tertiary_link",
                "street",
                "street_limited",
                "service",
                "track"
              ],
              true,
              false
            ]
          ],
          [
            "==",
            ["geometry-type"],
            "LineString"
          ]
        ],
        "layout": {},
        "paint": {
          "line-width": [
            "interpolate",
            ["exponential", 1.5],
            ["zoom"],
            13,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              4,
              ["secondary", "tertiary"],
              2.5,
              [
                "motorway_link",
                "trunk_link",
                "street",
                "street_limited",
                "primary_link"
              ],
              1,
              0.5
            ],
            18,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              32,
              ["secondary", "tertiary"],
              26,
              [
                "motorway_link",
                "trunk_link",
                "street",
                "street_limited",
                "primary_link"
              ],
              18,
              12
            ]
          ],
          "line-color": "rgb(68, 68, 68)"
        }
      },
      {
        "id": "road-simple",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "road-network",
          "mapbox:group": "Road network, surface"
        },
        "source": "composite",
        "source-layer": "road",
        "minzoom": 5,
        "filter": [
          "all",
          [
            "step",
            ["zoom"],
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk"],
              true,
              false
            ],
            6,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              true,
              false
            ],
            8,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary", "secondary"],
              true,
              false
            ],
            10,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "trunk",
                "primary",
                "secondary",
                "tertiary",
                "motorway_link",
                "trunk_link"
              ],
              true,
              false
            ],
            11,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "secondary",
                "tertiary",
                "street"
              ],
              true,
              false
            ],
            12,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "secondary",
                "tertiary",
                "street",
                "street_limited",
                "primary_link"
              ],
              true,
              false
            ],
            13,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "secondary",
                "tertiary",
                "street",
                "street_limited",
                "primary_link",
                "track"
              ],
              true,
              false
            ],
            14,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "primary_link",
                "secondary",
                "secondary_link",
                "tertiary",
                "tertiary_link",
                "street",
                "street_limited",
                "service",
                "track"
              ],
              true,
              false
            ]
          ],
          [
            "match",
            ["get", "structure"],
            ["none", "ford"],
            true,
            false
          ],
          [
            "==",
            ["geometry-type"],
            "LineString"
          ]
        ],
        "layout": {
          "line-cap": [
            "step",
            ["zoom"],
            "butt",
            14,
            "round"
          ],
          "line-join": [
            "step",
            ["zoom"],
            "miter",
            14,
            "round"
          ]
        },
        "paint": {
          "line-width": [
            "interpolate",
            ["exponential", 1.5],
            ["zoom"],
            5,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              0.75,
              ["secondary", "tertiary"],
              0.1,
              0
            ],
            13,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              4,
              ["secondary", "tertiary"],
              2.5,
              [
                "motorway_link",
                "trunk_link",
                "primary_link",
                "street",
                "street_limited"
              ],
              1,
              0.5
            ],
            18,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              32,
              ["secondary", "tertiary"],
              26,
              [
                "motorway_link",
                "trunk_link",
                "primary_link",
                "street",
                "street_limited"
              ],
              18,
              10
            ]
          ],
          "line-color": "rgb(68, 68, 68)"
        }
      },
      {
        "id": "bridge-case-simple",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "road-network",
          "mapbox:group": "Road network, bridges"
        },
        "source": "composite",
        "source-layer": "road",
        "minzoom": 13,
        "filter": [
          "all",
          [
            "==",
            ["get", "structure"],
            "bridge"
          ],
          [
            "step",
            ["zoom"],
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "secondary",
                "tertiary",
                "street",
                "street_limited",
                "primary_link",
                "track"
              ],
              true,
              false
            ],
            14,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "primary_link",
                "secondary",
                "secondary_link",
                "tertiary",
                "tertiary_link",
                "street",
                "street_limited",
                "service",
                "track"
              ],
              true,
              false
            ]
          ],
          [
            "==",
            ["geometry-type"],
            "LineString"
          ]
        ],
        "layout": {
          "line-join": [
            "step",
            ["zoom"],
            "miter",
            14,
            "round"
          ]
        },
        "paint": {
          "line-width": [
            "interpolate",
            ["exponential", 1.5],
            ["zoom"],
            13,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              6,
              ["secondary", "tertiary"],
              4,
              [
                "motorway_link",
                "trunk_link",
                "street",
                "street_limited",
                "primary_link"
              ],
              2.5,
              1.25
            ],
            18,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              36,
              ["secondary", "tertiary"],
              30,
              [
                "motorway_link",
                "trunk_link",
                "street",
                "street_limited",
                "primary_link"
              ],
              22,
              16
            ]
          ],
          "line-color": "rgb(47, 47, 47)"
        }
      },
      {
        "id": "bridge-simple",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "road-network",
          "mapbox:group": "Road network, bridges"
        },
        "source": "composite",
        "source-layer": "road",
        "minzoom": 13,
        "filter": [
          "all",
          [
            "==",
            ["get", "structure"],
            "bridge"
          ],
          [
            "step",
            ["zoom"],
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk"],
              true,
              false
            ],
            13,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "secondary",
                "tertiary",
                "street",
                "street_limited",
                "primary_link",
                "track"
              ],
              true,
              false
            ],
            14,
            [
              "match",
              ["get", "class"],
              [
                "motorway",
                "motorway_link",
                "trunk",
                "trunk_link",
                "primary",
                "primary_link",
                "secondary",
                "secondary_link",
                "tertiary",
                "tertiary_link",
                "street",
                "street_limited",
                "service",
                "track"
              ],
              true,
              false
            ]
          ],
          [
            "==",
            ["geometry-type"],
            "LineString"
          ]
        ],
        "layout": {
          "line-cap": [
            "step",
            ["zoom"],
            "butt",
            14,
            "round"
          ],
          "line-join": [
            "step",
            ["zoom"],
            "miter",
            14,
            "round"
          ]
        },
        "paint": {
          "line-width": [
            "interpolate",
            ["exponential", 1.5],
            ["zoom"],
            13,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              4,
              ["secondary", "tertiary"],
              2.5,
              [
                "motorway_link",
                "trunk_link",
                "street",
                "street_limited",
                "primary_link"
              ],
              1,
              0.5
            ],
            18,
            [
              "match",
              ["get", "class"],
              ["motorway", "trunk", "primary"],
              32,
              ["secondary", "tertiary"],
              26,
              [
                "motorway_link",
                "trunk_link",
                "street",
                "street_limited",
                "primary_link"
              ],
              18,
              12
            ]
          ],
          "line-color": "rgb(68, 68, 68)"
        }
      },
      {
        "id": "admin-1-boundary-bg",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "admin-boundaries",
          "mapbox:group": "Administrative boundaries, admin"
        },
        "source": "composite",
        "source-layer": "admin",
        "minzoom": 7,
        "filter": [
          "all",
          [
            "==",
            ["get", "admin_level"],
            1
          ],
          [
            "==",
            ["get", "maritime"],
            "false"
          ],
          [
            "match",
            ["get", "worldview"],
            ["all", "US"],
            true,
            false
          ]
        ],
        "layout": {"line-join": "bevel"},
        "paint": {
          "line-color": [
            "interpolate",
            ["linear"],
            ["zoom"],
            8,
            "rgb(36, 36, 36)",
            16,
            "rgb(36, 36, 36)"
          ],
          "line-width": [
            "interpolate",
            ["linear"],
            ["zoom"],
            7,
            3.75,
            12,
            5.5
          ],
          "line-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            7,
            0,
            8,
            0.75
          ],
          "line-dasharray": [1, 0],
          "line-blur": [
            "interpolate",
            ["linear"],
            ["zoom"],
            3,
            0,
            8,
            3
          ]
        }
      },
      {
        "id": "admin-0-boundary-bg",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "admin-boundaries",
          "mapbox:group": "Administrative boundaries, admin"
        },
        "source": "composite",
        "source-layer": "admin",
        "minzoom": 1,
        "filter": [
          "all",
          [
            "==",
            ["get", "admin_level"],
            0
          ],
          [
            "==",
            ["get", "maritime"],
            "false"
          ],
          [
            "match",
            ["get", "worldview"],
            ["all", "US"],
            true,
            false
          ]
        ],
        "layout": {},
        "paint": {
          "line-width": [
            "interpolate",
            ["linear"],
            ["zoom"],
            3,
            3.5,
            10,
            8
          ],
          "line-color": "rgb(36, 36, 36)",
          "line-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            3,
            0,
            4,
            0.5
          ],
          "line-blur": [
            "interpolate",
            ["linear"],
            ["zoom"],
            3,
            0,
            10,
            2
          ]
        }
      },
      {
        "id": "admin-1-boundary",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "admin-boundaries",
          "mapbox:group": "Administrative boundaries, admin"
        },
        "source": "composite",
        "source-layer": "admin",
        "minzoom": 2,
        "filter": [
          "all",
          [
            "==",
            ["get", "admin_level"],
            1
          ],
          [
            "==",
            ["get", "maritime"],
            "false"
          ],
          [
            "match",
            ["get", "worldview"],
            ["all", "US"],
            true,
            false
          ]
        ],
        "layout": {"line-join": "round", "line-cap": "round"},
        "paint": {
          "line-dasharray": [
            "step",
            ["zoom"],
            [
              "literal",
              [1, 3.5, 6, 3.5]
            ],
            6,
            [
              "literal",
              [1, 4, 7, 4]
            ],
            10,
            [
              "literal",
              [0.6, 4, 6, 4]
            ],
            13,
            [
              "literal",
              [0.7, 4, 7, 4]
            ]
          ],
          "line-width": [
            "interpolate",
            ["linear"],
            ["zoom"],
            7,
            0.75,
            12,
            1.5
          ],
          "line-opacity": [
            "interpolate",
            ["linear"],
            ["zoom"],
            2,
            0,
            3,
            1
          ],
          "line-color": [
            "interpolate",
            ["linear"],
            ["zoom"],
            3,
            "rgb(70, 70, 70)",
            7,
            "rgb(104, 104, 104)"
          ]
        }
      },
      {
        "id": "admin-0-boundary",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "admin-boundaries",
          "mapbox:group": "Administrative boundaries, admin"
        },
        "source": "composite",
        "source-layer": "admin",
        "minzoom": 1,
        "filter": [
          "all",
          [
            "==",
            ["get", "admin_level"],
            0
          ],
          [
            "==",
            ["get", "disputed"],
            "false"
          ],
          [
            "==",
            ["get", "maritime"],
            "false"
          ],
          [
            "match",
            ["get", "worldview"],
            ["all", "US"],
            true,
            false
          ]
        ],
        "layout": {"line-join": "round", "line-cap": "round"},
        "paint": {
          "line-color": "rgb(110, 110, 110)",
          "line-width": [
            "interpolate",
            ["linear"],
            ["zoom"],
            3,
            0.5,
            10,
            2
          ],
          "line-dasharray": [7, 4]
        }
      },
      {
        "id": "admin-0-boundary-disputed",
        "type": "line",
        "metadata": {
          "mapbox:featureComponent": "admin-boundaries",
          "mapbox:group": "Administrative boundaries, admin"
        },
        "source": "composite",
        "source-layer": "admin",
        "minzoom": 1,
        "filter": [
          "all",
          [
            "==",
            ["get", "disputed"],
            "true"
          ],
          [
            "==",
            ["get", "admin_level"],
            0
          ],
          [
            "==",
            ["get", "maritime"],
            "false"
          ],
          [
            "match",
            ["get", "worldview"],
            ["all", "US"],
            true,
            false
          ]
        ],
        "layout": {"line-join": "round"},
        "paint": {
          "line-color": "rgb(110, 110, 110)",
          "line-width": [
            "interpolate",
            ["linear"],
            ["zoom"],
            3,
            0.5,
            10,
            2
          ],
          "line-dasharray": [
            "step",
            ["zoom"],
            [
              "literal",
              [3.25, 3.25]
            ],
            6,
            [
              "literal",
              [2.5, 2.5]
            ],
            7,
            [
              "literal",
              [2, 2.25]
            ],
            8,
            [
              "literal",
              [1.75, 2]
            ]
          ]
        }
      },
      {
        "id": "waterway-label",
        "type": "symbol",
        "metadata": {
          "mapbox:featureComponent": "natural-features",
          "mapbox:group": "Natural features, natural-labels"
        },
        "source": "composite",
        "source-layer": "natural_label",
        "minzoom": 13,
        "filter": [
          "all",
          [
            "match",
            ["get", "class"],
            ["canal", "river", "stream"],
            [
              "match",
              ["get", "worldview"],
              ["all", "US"],
              true,
              false
            ],
            ["disputed_canal", "disputed_river", "disputed_stream"],
            [
              "all",
              [
                "==",
                ["get", "disputed"],
                "true"
              ],
              [
                "match",
                ["get", "worldview"],
                ["all", "US"],
                true,
                false
              ]
            ],
            false
          ],
          [
            "==",
            ["geometry-type"],
            "LineString"
          ]
        ],
        "layout": {
          "text-font": ["DIN Pro Italic", "Arial Unicode MS Regular"],
          "text-max-angle": 30,
          "symbol-spacing": [
            "interpolate",
            ["linear", 1],
            ["zoom"],
            15,
            250,
            17,
            400
          ],
          "text-size": [
            "interpolate",
            ["linear"],
            ["zoom"],
            13,
            12,
            18,
            16
          ],
          "symbol-placement": "line",
          "text-pitch-alignment": "viewport",
          "text-field": [
            "coalesce",
            ["get", "name_en"],
            ["get", "name"]
          ]
        },
        "paint": {"text-color": "rgb(96, 96, 96)"}
      },
      {
        "id": "natural-line-label",
        "type": "symbol",
        "metadata": {
          "mapbox:featureComponent": "natural-features",
          "mapbox:group": "Natural features, natural-labels"
        },
        "source": "composite",
        "source-layer": "natural_label",
        "minzoom": 4,
        "filter": [
          "all",
          [
            "match",
            ["get", "class"],
            ["glacier", "landform"],
            [
              "match",
              ["get", "worldview"],
              ["all", "US"],
              true,
              false
            ],
            ["disputed_glacier", "disputed_landform"],
            [
              "all",
              [
                "==",
                ["get", "disputed"],
                "true"
              ],
              [
                "match",
                ["get", "worldview"],
                ["all", "US"],
                true,
                false
              ]
            ],
            false
          ],
          [
            "==",
            ["geometry-type"],
            "LineString"
          ],
          [
            "<=",
            ["get", "filterrank"],
            1
          ]
        ],
        "layout": {
          "text-size": [
            "step",
            ["zoom"],
            [
              "step",
              ["get", "sizerank"],
              18,
              5,
              12
            ],
            17,
            [
              "step",
              ["get", "sizerank"],
              18,
              13,
              12
            ]
          ],
          "text-max-angle": 30,
          "text-field": [
            "coalesce",
            ["get", "name_en"],
            ["get", "name"]
          ],
          "text-font": ["DIN Pro Medium", "Arial Unicode MS Regular"],
          "symbol-placement": "line-center",
          "text-pitch-alignment": "viewport"
        },
        "paint": {
          "text-halo-width": 0.5,
          "text-halo-color": "rgb(14, 14, 14)",
          "text-halo-blur": 0.5,
          "text-color": "rgb(175, 175, 175)"
        }
      },
      {
        "id": "natural-point-label",
        "type": "symbol",
        "metadata": {
          "mapbox:featureComponent": "natural-features",
          "mapbox:group": "Natural features, natural-labels"
        },
        "source": "composite",
        "source-layer": "natural_label",
        "minzoom": 4,
        "filter": [
          "all",
          [
            "match",
            ["get", "class"],
            ["dock", "glacier", "landform", "water_feature", "wetland"],
            [
              "match",
              ["get", "worldview"],
              ["all", "US"],
              true,
              false
            ],
            [
              "disputed_dock",
              "disputed_glacier",
              "disputed_landform",
              "disputed_water_feature",
              "disputed_wetland"
            ],
            [
              "all",
              [
                "==",
                ["get", "disputed"],
                "true"
              ],
              [
                "match",
                ["get", "worldview"],
                ["all", "US"],
                true,
                false
              ]
            ],
            false
          ],
          [
            "==",
            ["geometry-type"],
            "Point"
          ],
          [
            "<=",
            ["get", "filterrank"],
            1
          ]
        ],
        "layout": {
          "text-size": [
            "step",
            ["zoom"],
            [
              "step",
              ["get", "sizerank"],
              18,
              5,
              12
            ],
            17,
            [
              "step",
              ["get", "sizerank"],
              18,
              13,
              12
            ]
          ],
          "icon-image": "",
          "text-font": ["DIN Pro Medium", "Arial Unicode MS Regular"],
          "text-offset": [
            "literal",
            [0, 0]
          ],
          "text-field": [
            "coalesce",
            ["get", "name_en"],
            ["get", "name"]
          ]
        },
        "paint": {
          "icon-opacity": [
            "step",
            ["zoom"],
            [
              "step",
              ["get", "sizerank"],
              0,
              5,
              1
            ],
            17,
            [
              "step",
              ["get", "sizerank"],
              0,
              13,
              1
            ]
          ],
          "text-halo-color": "rgb(14, 14, 14)",
          "text-halo-width": 0.5,
          "text-halo-blur": 0.5,
          "text-color": "rgb(175, 175, 175)"
        }
      },
      {
        "id": "water-line-label",
        "type": "symbol",
        "metadata": {
          "mapbox:featureComponent": "natural-features",
          "mapbox:group": "Natural features, natural-labels"
        },
        "source": "composite",
        "source-layer": "natural_label",
        "filter": [
          "all",
          [
            "match",
            ["get", "class"],
            ["bay", "ocean", "reservoir", "sea", "water"],
            [
              "match",
              ["get", "worldview"],
              ["all", "US"],
              true,
              false
            ],
            [
              "disputed_bay",
              "disputed_ocean",
              "disputed_reservoir",
              "disputed_sea",
              "disputed_water"
            ],
            [
              "all",
              [
                "==",
                ["get", "disputed"],
                "true"
              ],
              [
                "match",
                ["get", "worldview"],
                ["all", "US"],
                true,
                false
              ]
            ],
            false
          ],
          [
            "==",
            ["geometry-type"],
            "LineString"
          ]
        ],
        "layout": {
          "text-size": [
            "interpolate",
            ["linear"],
            ["zoom"],
            7,
            [
              "step",
              ["get", "sizerank"],
              20,
              6,
              18,
              12,
              12
            ],
            10,
            [
              "step",
              ["get", "sizerank"],
              15,
              9,
              12
            ],
            18,
            [
              "step",
              ["get", "sizerank"],
              15,
              9,
              14
            ]
          ],
          "text-max-angle": 30,
          "text-letter-spacing": [
            "match",
            ["get", "class"],
            "ocean",
            0.25,
            ["sea", "bay"],
            0.15,
            0
          ],
          "text-font": ["DIN Pro Italic", "Arial Unicode MS Regular"],
          "symbol-placement": "line-center",
          "text-pitch-alignment": "viewport",
          "text-field": [
            "coalesce",
            ["get", "name_en"],
            ["get", "name"]
          ]
        },
        "paint": {"text-color": "rgb(96, 96, 96)"}
      },
      {
        "id": "water-point-label",
        "type": "symbol",
        "metadata": {
          "mapbox:featureComponent": "natural-features",
          "mapbox:group": "Natural features, natural-labels"
        },
        "source": "composite",
        "source-layer": "natural_label",
        "filter": [
          "all",
          [
            "match",
            ["get", "class"],
            ["bay", "ocean", "reservoir", "sea", "water"],
            [
              "match",
              ["get", "worldview"],
              ["all", "US"],
              true,
              false
            ],
            [
              "disputed_bay",
              "disputed_ocean",
              "disputed_reservoir",
              "disputed_sea",
              "disputed_water"
            ],
            [
              "all",
              [
                "==",
                ["get", "disputed"],
                "true"
              ],
              [
                "match",
                ["get", "worldview"],
                ["all", "US"],
                true,
                false
              ]
            ],
            false
          ],
          [
            "==",
            ["geometry-type"],
            "Point"
          ]
        ],
        "layout": {
          "text-line-height": 1.3,
          "text-size": [
            "interpolate",
            ["linear"],
            ["zoom"],
            7,
            [
              "step",
              ["get", "sizerank"],
              20,
              6,
              15,
              12,
              12
            ],
            10,
            [
              "step",
              ["get", "sizerank"],
              15,
              9,
              12
            ]
          ],
          "text-font": ["DIN Pro Italic", "Arial Unicode MS Regular"],
          "text-field": [
            "coalesce",
            ["get", "name_en"],
            ["get", "name"]
          ],
          "text-letter-spacing": [
            "match",
            ["get", "class"],
            "ocean",
            0.25,
            ["bay", "sea"],
            0.15,
            0.01
          ],
          "text-max-width": [
            "match",
            ["get", "class"],
            "ocean",
            4,
            "sea",
            5,
            ["bay", "water"],
            7,
            10
          ]
        },
        "paint": {"text-color": "rgb(96, 96, 96)"}
      },
      {
        "id": "poi-label",
        "type": "symbol",
        "metadata": {
          "mapbox:featureComponent": "point-of-interest-labels",
          "mapbox:group": "Point of interest labels, poi-labels"
        },
        "source": "composite",
        "source-layer": "poi_label",
        "minzoom": 6,
        "filter": [
          "<=",
          ["get", "filterrank"],
          [
            "+",
            [
              "step",
              ["zoom"],
              0,
              16,
              1,
              17,
              2
            ],
            1
          ]
        ],
        "layout": {
          "text-size": [
            "step",
            ["zoom"],
            [
              "step",
              ["get", "sizerank"],
              18,
              5,
              12
            ],
            17,
            [
              "step",
              ["get", "sizerank"],
              18,
              13,
              12
            ]
          ],
          "icon-image": "",
          "text-font": ["DIN Pro Medium", "Arial Unicode MS Regular"],
          "text-offset": [0, 0],
          "text-anchor": [
            "step",
            ["zoom"],
            [
              "step",
              ["get", "sizerank"],
              "center",
              5,
              "top"
            ],
            17,
            [
              "step",
              ["get", "sizerank"],
              "center",
              13,
              "top"
            ]
          ],
          "text-field": [
            "coalesce",
            ["get", "name_en"],
            ["get", "name"]
          ]
        },
        "paint": {
          "text-halo-color": "rgb(14, 14, 14)",
          "text-halo-width": 0.5,
          "text-halo-blur": 0.5,
          "text-color": [
            "step",
            ["zoom"],
            [
              "step",
              ["get", "sizerank"],
              "rgb(104, 104, 104)",
              5,
              "rgb(142, 142, 142)"
            ],
            17,
            [
              "step",
              ["get", "sizerank"],
              "rgb(104, 104, 104)",
              13,
              "rgb(142, 142, 142)"
            ]
          ]
        }
      },
      {
        "id": "settlement-minor-label",
        "type": "symbol",
        "metadata": {
          "mapbox:featureComponent": "place-labels",
          "mapbox:group": "Place labels, place-labels"
        },
        "source": "composite",
        "source-layer": "place_label",
        "minzoom": 3,
        "maxzoom": 13,
        "filter": [
          "all",
          [
            "<=",
            ["get", "filterrank"],
            2
          ],
          [
            "match",
            ["get", "class"],
            "settlement",
            [
              "match",
              ["get", "worldview"],
              ["all", "US"],
              true,
              false
            ],
            "disputed_settlement",
            [
              "all",
              [
                "==",
                ["get", "disputed"],
                "true"
              ],
              [
                "match",
                ["get", "worldview"],
                ["all", "US"],
                true,
                false
              ]
            ],
            false
          ],
          [
            "step",
            ["zoom"],
            [
              ">",
              ["get", "symbolrank"],
              6
            ],
            4,
            [
              ">=",
              ["get", "symbolrank"],
              7
            ],
            6,
            [
              ">=",
              ["get", "symbolrank"],
              8
            ],
            7,
            [
              ">=",
              ["get", "symbolrank"],
              10
            ],
            10,
            [
              ">=",
              ["get", "symbolrank"],
              11
            ],
            11,
            [
              ">=",
              ["get", "symbolrank"],
              13
            ],
            12,
            [
              ">=",
              ["get", "symbolrank"],
              15
            ]
          ]
        ],
        "layout": {
          "icon-image": "",
          "text-font": ["DIN Pro Regular", "Arial Unicode MS Regular"],
          "text-radial-offset": [
            "step",
            ["zoom"],
            [
              "match",
              ["get", "capital"],
              2,
              0.6,
              0.55
            ],
            8,
            0
          ],
          "text-anchor": [
            "step",
            ["zoom"],
            "center",
            8,
            "center"
          ],
          "text-field": [
            "coalesce",
            ["get", "name_en"],
            ["get", "name"]
          ],
          "text-max-width": 7,
          "text-line-height": 1.1,
          "text-size": [
            "interpolate",
            ["cubic-bezier", 0.2, 0, 0.9, 1],
            ["zoom"],
            3,
            [
              "step",
              ["get", "symbolrank"],
              12,
              9,
              11,
              10,
              10.5,
              12,
              9.5,
              14,
              8.5,
              16,
              6.5,
              17,
              4
            ],
            13,
            [
              "step",
              ["get", "symbolrank"],
              23,
              9,
              21,
              10,
              19,
              11,
              17,
              12,
              16,
              13,
              15,
              15,
              13
            ]
          ]
        },
        "paint": {
          "text-color": [
            "step",
            ["get", "symbolrank"],
            "rgb(175, 175, 175)",
            11,
            "rgb(142, 142, 142)",
            16,
            "rgb(127, 127, 127)"
          ],
          "text-halo-color": "rgb(14, 14, 14)",
          "text-halo-width": 1,
          "icon-opacity": [
            "step",
            ["zoom"],
            1,
            8,
            0
          ],
          "text-halo-blur": 1
        }
      },
      {
        "id": "settlement-major-label",
        "type": "symbol",
        "metadata": {
          "mapbox:featureComponent": "place-labels",
          "mapbox:group": "Place labels, place-labels"
        },
        "source": "composite",
        "source-layer": "place_label",
        "minzoom": 3,
        "maxzoom": 15,
        "filter": [
          "all",
          [
            "<=",
            ["get", "filterrank"],
            2
          ],
          [
            "match",
            ["get", "class"],
            "settlement",
            [
              "match",
              ["get", "worldview"],
              ["all", "US"],
              true,
              false
            ],
            "disputed_settlement",
            [
              "all",
              [
                "==",
                ["get", "disputed"],
                "true"
              ],
              [
                "match",
                ["get", "worldview"],
                ["all", "US"],
                true,
                false
              ]
            ],
            false
          ],
          [
            "step",
            ["zoom"],
            false,
            3,
            [
              "<=",
              ["get", "symbolrank"],
              6
            ],
            4,
            [
              "<",
              ["get", "symbolrank"],
              7
            ],
            6,
            [
              "<",
              ["get", "symbolrank"],
              8
            ],
            7,
            [
              "<",
              ["get", "symbolrank"],
              10
            ],
            10,
            [
              "<",
              ["get", "symbolrank"],
              11
            ],
            11,
            [
              "<",
              ["get", "symbolrank"],
              13
            ],
            12,
            [
              "<",
              ["get", "symbolrank"],
              15
            ],
            13,
            [
              ">=",
              ["get", "symbolrank"],
              11
            ],
            14,
            [
              ">=",
              ["get", "symbolrank"],
              15
            ]
          ]
        ],
        "layout": {
          "icon-image": "",
          "text-font": ["DIN Pro Medium", "Arial Unicode MS Regular"],
          "text-radial-offset": [
            "step",
            ["zoom"],
            [
              "match",
              ["get", "capital"],
              2,
              0.6,
              0.55
            ],
            8,
            0
          ],
          "text-anchor": [
            "step",
            ["zoom"],
            "center",
            8,
            "center"
          ],
          "text-field": [
            "coalesce",
            ["get", "name_en"],
            ["get", "name"]
          ],
          "text-max-width": 7,
          "text-line-height": 1.1,
          "text-size": [
            "interpolate",
            ["cubic-bezier", 0.2, 0, 0.9, 1],
            ["zoom"],
            3,
            [
              "step",
              ["get", "symbolrank"],
              13,
              6,
              12
            ],
            6,
            [
              "step",
              ["get", "symbolrank"],
              16,
              6,
              15,
              7,
              14
            ],
            8,
            [
              "step",
              ["get", "symbolrank"],
              18,
              9,
              17,
              10,
              15
            ],
            15,
            [
              "step",
              ["get", "symbolrank"],
              23,
              9,
              22,
              10,
              20,
              11,
              18,
              12,
              16,
              13,
              15,
              15,
              13
            ]
          ]
        },
        "paint": {
          "text-color": [
            "step",
            ["get", "symbolrank"],
            "rgb(175, 175, 175)",
            11,
            "rgb(142, 142, 142)",
            16,
            "rgb(127, 127, 127)"
          ],
          "text-halo-color": "rgb(14, 14, 14)",
          "text-halo-width": 1,
          "icon-opacity": [
            "step",
            ["zoom"],
            1,
            8,
            0
          ],
          "text-halo-blur": 1
        }
      }
    ],
    "created": "2022-05-22T14:54:49.023Z",
    "modified": "2022-05-22T14:55:11.242Z",
    "id": "cl3hf82ox003315qg72h9wx5y",
    "owner": "raxysstudios",
    "visibility": "private",
    "protected": false,
    "draft": false
  };
}
