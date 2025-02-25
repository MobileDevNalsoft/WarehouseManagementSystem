export function initNodes(three, scene) {
  const THREE = three;
  class Node {
    constructor(name, point) {
      this.name = name;
      this.point = point;
      this.adjacent = [];
    }
  }
  let nodes = [];
  const data = JSON.parse(window.localStorage.getItem("facilityData"));
  let aisleBayPoints = {};
  let intermediatePoints = {};
  let adjacencyList = {};
  switch (data.model) {
    case "warehouse":
      aisleBayPoints = {
        1: {
          3: new THREE.Vector3(-138.0, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-138.0, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-138.0, 6.19, -110.13989544214405),
        },
        2: {
          3: new THREE.Vector3(-116.0, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-116.0, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-116.0, 6.19, -110.13989544214405),
        },
        3: {
          3: new THREE.Vector3(-92.4, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-92.4, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-92.4, 6.19, -110.13989544214405),
        },
        4: {
          3: new THREE.Vector3(-69.2, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-69.2, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-69.2, 6.19, -110.13989544214405),
        },
        5: {
          3: new THREE.Vector3(-46.4, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-46.4, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-46.4, 6.19, -110.13989544214405),
        },
        6: {
          3: new THREE.Vector3(-23.6, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-23.6, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-23.6, 6.19, -110.13989544214405),
        },
      };
      intermediatePoints = {
        a1: new THREE.Vector3(-138.0, 6.19, -132.0),
        a2: new THREE.Vector3(-116.0, 6.19, -132.0),
        a3: new THREE.Vector3(-92.4, 6.19, -132.0),
        a4: new THREE.Vector3(-69.2, 6.19, -132.0),
        a5: new THREE.Vector3(-46.4, 6.19, -132.0),
        a6: new THREE.Vector3(-23.6, 6.19, -132.0),

        b1: new THREE.Vector3(-138.0, 6.19, -98.0),
        b2: new THREE.Vector3(-116.0, 6.19, -98.0),
        b3: new THREE.Vector3(-92.4, 6.19, -98.0),
        b4: new THREE.Vector3(-69.2, 6.19, -98.0),
        b5: new THREE.Vector3(-46.4, 6.19, -98.0),
        b6: new THREE.Vector3(-23.6, 6.19, -98.0),

        p1: new THREE.Vector3(-125.16835094362332, 6.19, -91),
        p2: new THREE.Vector3(-104.0724984440678, 6.19, -91),
        p3: new THREE.Vector3(-84.20038905146427, 6.19, -91),
        p4: new THREE.Vector3(-46.4, 6.19, -91),

        p5: new THREE.Vector3(-14.035990842471623, 6.19, -91),

        p6: new THREE.Vector3(-14.185505861653581, 6.19, -107.84385506088879),
        p7: new THREE.Vector3(-14.114602359858907, 6.19, -132.0),

        p8: new THREE.Vector3(-14.197195127688875, 6.19, -77.49013059402137),
        p9: new THREE.Vector3(-14.264927005311744, 6.19, -61.64698518320672),
        p10: new THREE.Vector3(-104.0, 6.19, -98.0),
        receiving: new THREE.Vector3(
          0.569215386407393,
          6.19,
          -77.49013059402137
        ),
        inspection: new THREE.Vector3(-8, 6.19 - 106.89068254045604),
        activity: new THREE.Vector3(
          -24.21696383882049,
          6.19,
          -60.86146377835111
        ),
        staging: new THREE.Vector3(
          -125.14815693589341,
          6.19,
          -76.65696617010423
        ),
      };

      adjacencyList = {
        Node_1_1: ["Node_1_2", "Node_b1"],
        Node_1_2: ["Node_1_1", "Node_1_3"],
        Node_1_3: ["Node_1_2", "Node_a1"],
        Node_2_1: ["Node_2_2", "Node_b2"],
        Node_2_2: ["Node_2_1", "Node_2_3"],
        Node_2_3: ["Node_2_2", "Node_a2"],
        Node_3_1: ["Node_3_2", "Node_b3"],
        Node_3_2: ["Node_3_1", "Node_3_3"],
        Node_3_3: ["Node_3_2", "Node_a3"],
        Node_4_1: ["Node_4_2", "Node_b4"],
        Node_4_2: ["Node_4_1", "Node_4_3"],
        Node_4_3: ["Node_4_2", "Node_a4"],
        Node_5_1: ["Node_5_2", "Node_b5"],
        Node_5_2: ["Node_5_1", "Node_5_3"],
        Node_5_3: ["Node_5_2", "Node_a5"],
        Node_6_1: ["Node_6_2", "Node_b6"],
        Node_6_2: ["Node_6_1", "Node_6_3"],
        Node_6_3: ["Node_6_2", "Node_a6"],
        Node_a1: ["Node_1_3", "Node_a2"],
        Node_a2: ["Node_a1", "Node_2_3", "Node_a3"],
        Node_a3: ["Node_a2", "Node_3_3", "Node_a4"],
        Node_a4: ["Node_a3", "Node_4_3", "Node_a5"],
        Node_a5: ["Node_a4", "Node_5_3", "Node_a6"],
        Node_a6: ["Node_a5", "Node_6_3", "Node_p7"],
        Node_b1: ["Node_1_1", "Node_b2"],
        Node_b2: ["Node_b1", "Node_2_1", "Node_b3", "Node_p10"],
        Node_b3: ["Node_b2", "Node_3_1", "Node_b4", "Node_p10"],
        Node_b4: ["Node_b3", "Node_4_1", "Node_b5"],
        Node_b5: ["Node_b4", "Node_5_1", "Node_b6", "Node_p4"],
        Node_b6: ["Node_b5", "Node_6_1"],
        Node_p1: ["Node_p2", "Node_staging"],
        Node_p2: ["Node_p1", "Node_p3", "Node_p10"],
        Node_p3: ["Node_p2", "Node_p4"],
        Node_p4: ["Node_p3", "Node_p5", "Node_b5"],
        Node_p5: ["Node_p4", "Node_p6", "Node_p8"],
        Node_p6: ["Node_p5", "Node_p7", "Node_inspection"],
        Node_p7: ["Node_p6", "Node_a6"],
        Node_p8: ["Node_p5", "Node_p9", "Node_receiving"],
        Node_p9: ["Node_p8", "Node_activity"],
        Node_p10: ["Node_b2", "Node_b3", "Node_p2"],
        Node_receiving: ["Node_p8"],
        Node_activity: ["Node_p9"],
        Node_inspection: ["Node_p6"],
        Node_staging: ["Node_p1"],
      };
      break;
    case "storageArea":
      const rack1l = scene.getObjectByName("rack1l");
      const rack1r = scene.getObjectByName("rack1r");
      const rack2r = scene.getObjectByName("rack2r");
      const rack3r = scene.getObjectByName("rack3r");
      const rack4r = scene.getObjectByName("rack4r");
      const rack5r = scene.getObjectByName("rack5r");
      const initialPoint = new THREE.Vector3(56.5, -12.1, 74);
      aisleBayPoints = {
        1: {
          3: new THREE.Vector3(
            rack1l.position.x - 8,
            rack1l.position.y - 11.3,
            rack1l.position.z - 7
          ),
          2: new THREE.Vector3(
            rack1l.position.x - 8,
            rack1l.position.y - 11.3,
            rack1l.position.z
          ),
          1: new THREE.Vector3(
            rack1l.position.x - 8,
            rack1l.position.y - 11.3,
            rack1l.position.z + 7
          ),
        },
        2: {
          3: new THREE.Vector3(
            rack1r.position.x + 8.5,
            rack1r.position.y - 11.3,
            rack1r.position.z - 7
          ),
          2: new THREE.Vector3(
            rack1r.position.x + 8.5,
            rack1r.position.y - 11.3,
            rack1r.position.z
          ),
          1: new THREE.Vector3(
            rack1r.position.x + 8.5,
            rack1r.position.y - 11.3,
            rack1r.position.z + 7
          ),
        },
        3: {
          3: new THREE.Vector3(
            rack2r.position.x + 11,
            rack2r.position.y - 11.3,
            rack2r.position.z - 7
          ),
          2: new THREE.Vector3(
            rack2r.position.x + 11,
            rack2r.position.y - 11.3,
            rack2r.position.z
          ),
          1: new THREE.Vector3(
            rack2r.position.x + 11,
            rack2r.position.y - 11.3,
            rack2r.position.z + 7
          ),
        },
        4: {
          3: new THREE.Vector3(
            rack3r.position.x + 10,
            rack3r.position.y - 11.3,
            rack3r.position.z - 7
          ),
          2: new THREE.Vector3(
            rack3r.position.x + 10,
            rack3r.position.y - 11.3,
            rack3r.position.z
          ),
          1: new THREE.Vector3(
            rack3r.position.x + 10,
            rack3r.position.y - 11.3,
            rack3r.position.z + 7
          ),
        },
        5: {
          3: new THREE.Vector3(
            rack4r.position.x + 10,
            rack4r.position.y - 11.3,
            rack4r.position.z - 7
          ),
          2: new THREE.Vector3(
            rack4r.position.x + 10,
            rack4r.position.y - 11.3,
            rack4r.position.z
          ),
          1: new THREE.Vector3(
            rack4r.position.x + 10,
            rack4r.position.y - 11.3,
            rack4r.position.z + 7
          ),
        },
        6: {
          3: new THREE.Vector3(
            rack5r.position.x + 9,
            rack5r.position.y - 11.3,
            rack5r.position.z - 7
          ),
          2: new THREE.Vector3(
            rack5r.position.x + 9,
            rack5r.position.y - 11.3,
            rack5r.position.z
          ),
          1: new THREE.Vector3(
            rack5r.position.x + 9,
            rack5r.position.y - 11.3,
            rack5r.position.z + 7
          ),
        },
      };
      intermediatePoints = {};

      for (let i = 0; i < 113; i++) {
        const key = "a" + (i + 1);
        intermediatePoints[key] = new THREE.Vector3(
          initialPoint.x - i,
          initialPoint.y,
          initialPoint.z - 44
        );
      }

      for (let i = 0; i < 113; i++) {
        const key = "b" + (i + 1);
        intermediatePoints[key] = new THREE.Vector3(
          initialPoint.x - i,
          initialPoint.y,
          initialPoint.z - 9
        );
      }

      for (let i = 0; i < 113; i++) {
        const key = "p" + (i + 1);
        intermediatePoints[key] = new THREE.Vector3(
          initialPoint.x - i,
          initialPoint.y,
          initialPoint.z
        );
      }

      //for Node_p adjacency nodes
      adjacencyList["Node_p1"] = ["Node_p2"];
      for (let i = 2; i < 113; i++) {
        const node = "Node_p" + i;
        const rightNode = "Node_p" + (i - 1);
        const leftNode = "Node_p" + (i + 1);
        adjacencyList[node] = [rightNode, leftNode];
      }
      (adjacencyList["Node_p113"] = ["Node_p112"]),
        //for Node_b adjacency nodes
        (adjacencyList["Node_b1"] = ["Node_b2", "Node_6_1"]);
      for (let i = 2; i < 113; i++) {
        const node = "Node_b" + i;
        const rightNode = "Node_b" + (i - 1);
        const leftNode = "Node_b" + (i + 1);
        adjacencyList[node] = [rightNode, leftNode];
      }
      adjacencyList["Node_b113"] = ["Node_b112"];

      //for Node_a adjacency nodes
      adjacencyList["Node_a1"] = ["Node_a2", "Node_6_3"];
      for (let i = 2; i < 113; i++) {
        const node = "Node_a" + i;
        const rightNode = "Node_a" + (i - 1);
        const leftNode = "Node_a" + (i + 1);
        adjacencyList[node] = [rightNode, leftNode];
      }
      adjacencyList["Node_a113"] = ["Node_a112"];

      //for Node_p to Node_b connection
      adjacencyList["Node_p26"].push("Node_b26");
      adjacencyList["Node_p80"].push("Node_b80");

      //for Node_b to Node_p connection
      adjacencyList["Node_b26"].push("Node_p26");
      adjacencyList["Node_b80"].push("Node_p80");

      //for Node_b to bay 1 connection
      adjacencyList["Node_b23"].push("Node_5_1");
      adjacencyList["Node_b46"].push("Node_4_1");
      adjacencyList["Node_b68"].push("Node_3_1");
      adjacencyList["Node_b93"].push("Node_2_1");
      adjacencyList["Node_b113"].push("Node_1_1");

      //for bay 1 to Node_b and mid bay connection
      adjacencyList["Node_1_1"] = ["Node_1_2", "Node_b113"];
      adjacencyList["Node_2_1"] = ["Node_2_2", "Node_b93"];
      adjacencyList["Node_3_1"] = ["Node_3_2", "Node_b68"];
      adjacencyList["Node_4_1"] = ["Node_4_2", "Node_b46"];
      adjacencyList["Node_5_1"] = ["Node_5_2", "Node_b23"];
      adjacencyList["Node_6_1"] = ["Node_6_2", "Node_b1"];

      //for rack middle bay to bay 1 and bay 3 connection
      for (let i = 1; i <= 6; i++) {
        const node = "Node_" + i + "_2";
        const topNode = "Node_" + i + "_1";
        const bottomNode = "Node_" + i + "_3";
        adjacencyList[node] = [topNode, bottomNode];
      }

      //for bay 3 to mid bay and Node_a connection
      adjacencyList["Node_1_3"] = ["Node_1_2", "Node_a113"];
      adjacencyList["Node_2_3"] = ["Node_2_2", "Node_a93"];
      adjacencyList["Node_3_3"] = ["Node_3_2", "Node_a68"];
      adjacencyList["Node_4_3"] = ["Node_4_2", "Node_a46"];
      adjacencyList["Node_5_3"] = ["Node_5_2", "Node_a23"];
      adjacencyList["Node_6_3"] = ["Node_6_2", "Node_a1"];

      //for Node_a to bay 3 connection
      adjacencyList["Node_a23"].push("Node_5_3");
      adjacencyList["Node_a46"].push("Node_4_3");
      adjacencyList["Node_a68"].push("Node_3_3");
      adjacencyList["Node_a93"].push("Node_2_3");
      adjacencyList["Node_a113"].push("Node_1_3");
      break;
  }

  for (let aisle in aisleBayPoints) {
    for (let bay in aisleBayPoints[aisle]) {
      const point = aisleBayPoints[aisle][bay];
      const nodeName = `Node_${aisle}_${bay}`;
      nodes.push(new Node(nodeName, point));
    }
  }

  for (let intermediateaislePoint in intermediatePoints) {
    const point = intermediatePoints[intermediateaislePoint];
    const nodeName = `Node_${intermediateaislePoint}`;
    nodes.push(new Node(nodeName, point));
  }

  const nodeMap = new Map(nodes.map((node) => [node.name, node]));

  for (const [nodeName, adjacentNames] of Object.entries(adjacencyList)) {
    const node = nodeMap.get(nodeName);
    if (node) {
      node.adjacent = adjacentNames.map((adjName) => nodeMap.get(adjName));
    } else {
      console.error(`Node ${nodeName} is missing in nodeMap.`);
    }
  }
  return { nodeMap, nodes, aisleBayPoints, intermediatePoints };
}

export function getShortestPath(
  bins,
  nodeMap,
  nodes,
  aisleBayPoints,
  intermediatePoints,
  three,
  scene,
  camera,
  controls,
  agentGroup,
  renderer,
  waitPeriodAtPoints,
  color,
  lineColor,
  pathButtonId
) {
  const THREE = three;
  let finalPath = [];
  let checkpointCircles = [];
  let combinedPath = [];
  let arrows = [];
  let pathLine = [];

  const checkpoints = setupCheckpoints(bins);
  const nodesToVisit = findNodeNamesForPoints(checkpoints, nodes);

  console.warn("nodesToVisit", nodesToVisit);
  const { distMatrix, pathMatrix } = computeDistanceMatrix(
    nodesToVisit,
    nodeMap
  );
  const { minDist, path } = findShortestPath(
    nodesToVisit,
    distMatrix,
    pathMatrix,
    nodesToVisit[0],
    nodesToVisit[nodesToVisit.length - 1],
  );
  console.warn("Shortest Path Distance:", minDist, path, pathMatrix);

  for (let i = 0; i < path.length - 1; i++) {
    let start = path[i];
    let end = path[i + 1];
    finalPath = [...finalPath, ...pathMatrix[start][end]];
  }

  visualizePath(finalPath.map((name) => nodeMap.get(name).point));

  if (finalPath != []) {
    createBlinkingCircles(
      nodesToVisit.map((name) => nodeMap.get(name).point),
      intermediatePoints
    );
    combinedPath = [nodeMap.get(finalPath[0]).point];
    let start = finalPath[0];
    for (let i = 1; i < finalPath.length; i++) {
      if (start != finalPath[i]) {
        combinedPath.push(nodeMap.get(finalPath[i]).point);
      }
    }
    scene.add(agentGroup);
    agentGroup.position.set(
      combinedPath[0].x,
      combinedPath[0].y,
      combinedPath[0].z
    );
  }

  function findNodeNamesForPoints(randomPoints, nodes) {
    return randomPoints.map((point) => {
      return nodes.find((node) => {
        return (
          node.point.x === point.x &&
          node.point.y === point.y &&
          node.point.z === point.z
        );
      }).name;
    });
  }

  // breath-first-search is used to find the target node and its distance
  function bfs(startNode, targetNode) {
    const queue = [[startNode, [startNode.name]]]; // [currentNode, path] (path is an array of node names)
    const visited = new Set();

    while (queue.length > 0) {
      const [currentNode, path] = queue.shift(); // path will track the traversal sequence

      if (currentNode === targetNode)
        return { distance: path.length - 1, path }; // Return distance and the path

      if (visited.has(currentNode)) continue;

      visited.add(currentNode);

      for (const neighbor of currentNode.adjacent) {
        if (!visited.has(neighbor)) {
          queue.push([neighbor, [...path, neighbor.name]]); // Add neighbor to path
        }
      }
    }

    return { distance: Infinity, path: [] }; // No path found
  }

 // calculates the distance between two nodes and maintains distnace and path matrices  
  function computeDistanceMatrix(nodesToVisit, nodeMap) {
    const distMatrix = {};
    const pathMatrix = {}; // To store paths

    nodesToVisit.forEach((nodeName) => {
      distMatrix[nodeName] = {};
      pathMatrix[nodeName] = {}; // Initialize path for each node
      nodesToVisit.forEach((otherNodeName) => {
        if (nodeName !== otherNodeName) {
          const { distance, path } = bfs(
            nodeMap.get(nodeName),
            nodeMap.get(otherNodeName)
          );
          distMatrix[nodeName][otherNodeName] = distance;
          pathMatrix[nodeName][otherNodeName] = path;
        } else {
          distMatrix[nodeName][otherNodeName] = 0; // Distance to itself
          pathMatrix[nodeName][otherNodeName] = [nodeName]; // Path is just itself
        }
      });
    });

    return { distMatrix, pathMatrix };
  }

  // function findShortestPath(nodesToVisit, distMatrix, pathMatrix) {
  //   const n = nodesToVisit.length;
  //   const dp = Array(1 << n).fill(null).map(() => Array(n).fill(Infinity));
  //   const parent = Array(1 << n).fill(null).map(() => Array(n).fill(-1));
  //   const nodeIndex = nodesToVisit.reduce((map, name, index) => {
  //       map[name] = index;
  //       return map;
  //   }, {});

  //   dp[1][0] = 0; // Start at the first node (Node_1_1)

  //   for (let mask = 1; mask < (1 << n); mask++) {
  //       for (let u = 0; u < n; u++) {
  //           if (!(mask & (1 << u))) continue; // Skip if `u` is not in the current mask

  //           for (let v = 0; v < n; v++) {
  //               if (u === v || !(mask & (1 << v))) continue; // Skip if `v` is not in the mask or same as `u`
  //               const prevMask = mask ^ (1 << u); // Remove `u` from the current mask
  //               const cost = dp[prevMask][v] + distMatrix[nodesToVisit[v]][nodesToVisit[u]];

  //               if (cost < dp[mask][u]) {
  //                   dp[mask][u] = cost;
  //                   parent[mask][u] = v; // Track parent for reconstruction
  //               }
  //           }
  //       }
  //   }

  //   // Find the end node with the minimum cost
  //   let minDist = Infinity;
  //   let lastNode = -1;
  //   for (let u = 0; u < n; u++) {
  //       if (dp[(1 << n) - 1][u] < minDist) {
  //           minDist = dp[(1 << n) - 1][u];
  //           lastNode = u;
  //       }
  //   }

  //   // Reconstruct the path
  //   const finalPath = [];
  //   let mask = (1 << n) - 1;
  //   while (lastNode !== -1) {
  //       finalPath.unshift(nodesToVisit[lastNode]);
  //       const prevNode = parent[mask][lastNode];
  //       mask ^= 1 << lastNode; // Remove the last node from the mask
  //       lastNode = prevNode;
  //   }

  //   return { minDist, path: finalPath };
  // }

  // Main function to fetch the shoretest path with all the values set(distMatrix, nodes, startnode and endnode)  
  
  function findShortestPath(
    nodesToVisit,
    distMatrix,
    pathMatrix,
    startNode,
    endNode
  ) {
    const n = nodesToVisit.length;
    console.warn(startNode, endNode);
    const dp = Array(1 << n)
      .fill(null)
      .map(() => Array(n).fill(Infinity));
    const parent = Array(1 << n)
      .fill(null)
      .map(() => Array(n).fill(-1));
    const nodeIndex = nodesToVisit.reduce((map, name, index) => {
      map[name] = index;
      return map;
    }, {});

    // Ensure startNode and endNode are in nodesToVisit
    if (
      !nodeIndex.hasOwnProperty(startNode) ||
      !nodeIndex.hasOwnProperty(endNode)
    ) {
      throw new Error("Start or end node not found in nodesToVisit");
    }

    const startIdx = nodeIndex[startNode];
    const endIdx = nodeIndex[endNode];

    dp[1 << startIdx][startIdx] = 0; // Start at the fixed start node

    for (let mask = 1; mask < 1 << n; mask++) {
      for (let u = 0; u < n; u++) {
        if (!(mask & (1 << u))) continue; // Skip if `u` is not in the current mask

        for (let v = 0; v < n; v++) {
          if (u === v || !(mask & (1 << v))) continue; // Skip if `v` is not in the mask or same as `u`
          const prevMask = mask ^ (1 << u); // Remove `u` from the current mask
          const cost =
            dp[prevMask][v] + distMatrix[nodesToVisit[v]][nodesToVisit[u]];

          if (cost < dp[mask][u]) {
            dp[mask][u] = cost;
            parent[mask][u] = v; // Track parent for reconstruction
          }
        }
      }
    }

    // The ending point is fixed
    const mask = (1 << n) - 1; // All nodes visited
    const minDist = dp[mask][endIdx];

    // Reconstruct the path
    const finalPath = [];
    let lastNode = endIdx;
    let currentMask = mask;

    while (lastNode !== -1) {
      finalPath.unshift(nodesToVisit[lastNode]);
      const prevNode = parent[currentMask][lastNode];
      currentMask ^= 1 << lastNode; // Remove the last node from the mask
      lastNode = prevNode;
    }

    return { minDist, path: finalPath };
  }


  // mapping the binnames to the nodes
  function setupCheckpoints(binNames) {
    let binPoints = [];

    for (let index in binNames) {
      if (!binNames[index].toLowerCase().includes("area")) {
        if (binNames[index].startsWith("p")) {
          binPoints.push(intermediatePoints[binNames[index]]);
          continue;
        }
        const aisle = parseInt(binNames[index]); // Convert first character (aisle number) to an integer
        const bay = binNames[index][3]; // Extract the bay number from the bin
        const direction = binNames[index][1]; // Extract the direction ("R" or "L")

        // Handle right (R) or left (L) adjustment warnic if necessary
        const adjustedAisle = direction === "R" ? aisle + 1 : aisle; // Adjust if required

        // Get the corresponding Vector3 point
        const point = aisleBayPoints[adjustedAisle.toString()]?.[bay];
        if (!point) {
          console.warn(`No point found for bin: ${bins[index]}`);
          return null;
        }
        if (!binPoints.includes(point)) {
          binPoints.push(point);
        }
      } else {
        switch (binNames[index]) {
          case "inspectionArea":
            binPoints.push(intermediatePoints["inspection"]);
            break;
          case "activityArea":
            binPoints.push(intermediatePoints["activity"]);
            break;
          case "stagingArea":
            binPoints.push(intermediatePoints["staging"]);
            break;
          case "receivingArea":
            binPoints.push(intermediatePoints["receiving"]);
            break;
        }
      }
    }

    // Filter out any null points and warn the binPoints
    const validBinPoints = binPoints.filter((point) => point !== null);
    console.warn("Valid bin points:", validBinPoints);

    return validBinPoints;
  }

  // to load the circles that are to be highlighted
  function createBlinkingCircles(points, intermediatePoints) {
    checkpointCircles = [];
    const circleMaterial = new THREE.MeshBasicMaterial({
      color: color, // Yellow
      side: THREE.DoubleSide,
      transparent: true,
      opacity: 0.8, // Start opacity
    });
    let intermediatePointValues = [...Object.values(intermediatePoints)];
    points.forEach((point) => {
      if (!intermediatePointValues.includes(point)) {
        const circleGeometry = new THREE.CircleGeometry(1, 32); // Radius 2, 32 segments
        const circle = new THREE.Mesh(circleGeometry, circleMaterial);

        // Rotate to lie flat on the ground
        circle.rotation.x = -Math.PI / 2;

        // Position at the checkpoint
        circle.position.set(point.x, point.y + 0.1, point.z); // Slightly above ground
        scene.add(circle);
        checkpointCircles.push(circle);
      }
    });
  }

  // Function to visualize the path
  function visualizePath(path) {
    for (let i = 0; i < path.length - 1; i++) {
      const start = path[i];
      const end = path[i + 1];

      // Calculate the distance and direction
      const direction = new THREE.Vector3().subVectors(end, start);
      const distance = direction.length();

      // Create a cylinder geometry for the tube
      const tubeGeometry = new THREE.CylinderGeometry(0.3, 0.3, distance, 32); // Adjust radius (0.1) for thickness
      const tubeMaterial = new THREE.MeshBasicMaterial({ color: lineColor });
      const segment = new THREE.Mesh(tubeGeometry, tubeMaterial);

      // Position the segment midpoint between start and end
      segment.position.copy(start.clone().add(end).multiplyScalar(0.5));

      // Align the segment with the direction vector
      segment.lookAt(end);

      // Adjust orientation to align with the correct axis (default cylinder points along Y-axis)
      segment.rotateX(Math.PI / 2);

      // Add to the scene
      scene.add(segment);
      pathLine.push(segment);
    }
  }

    //animating the checkpoint circles 
  function animateCircles(delta) {
    const time = clock.getElapsedTime();

    checkpointCircles.forEach((circle, index) => {
      // Scale the circle up and down
      const scale = 1 + 0.2 * Math.sin(time * 2); // Adjust frequency with time multiplier
      circle.scale.set(scale, scale, scale);

      // Optionally adjust opacity for a fading effect
      circle.material.opacity = 0.5 + 0.5 * Math.sin(time * 2);
    });
  }
  // function drawArrowsForPath(path) {
  //   // Remove existing arrows
  //   arrows.forEach((arrow) => scene.remove(arrow));
  //   arrows.length = 0;

  //   // Iterate through the path to create arrows
  //   for (let i = 0; i < path.length - 1; i++) {
  //     const start = path[i].clone(); // Use cloned objects
  //     const end = path[i + 1].clone();

  //     // Calculate the direction vector
  //     const dir = new THREE.Vector3().subVectors(end, start).normalize();

  //     // Length of the arrow
  //     const length = start.distanceTo(end);

  //     // Create the arrow
  //     const arrow = new THREE.ArrowHelper(dir, start, length, 0xff0000, 2.5, 1); // Red arrow
  //     scene.add(arrow);
  //     arrows.push(arrow);
  //   }
  // }

  let waiting = false;
  // moving the object from one to another
  async function move(delta, waitPeriodAtPoints) {
    let SPEED = 5;
    if (!combinedPath || combinedPath.length <= 0 || waiting) {
      // console.warn("No combinedPath available for agent motion.");
      return;
    }

    const targetPosition = combinedPath[0];
    const direction = targetPosition.clone().sub(agentGroup.position);

    const distanceSq = direction.lengthSq();
    if (distanceSq > 0.05 * 0.05) {
      direction.normalize();
      // Calculate the target angle
      const targetAngle = Math.atan2(direction.x, direction.z);
      // Get current angle and calculate the shortest path
      let currentAngle = agentGroup.rotation.y;
      const angleDifference =
        THREE.MathUtils.euclideanModulo(
          targetAngle - currentAngle + Math.PI,
          Math.PI * 2
        ) - Math.PI;

      if (Math.abs(angleDifference) > 0.01) {
        currentAngle += angleDifference * delta * 2; // Smoothly interpolate rotation
        agentGroup.rotation.y = currentAngle;
      }
      const moveDistance = Math.min(delta * SPEED, Math.sqrt(distanceSq));
      agentGroup.position.add(direction.multiplyScalar(moveDistance));
    } else {
      agentGroup.position.copy(targetPosition);
      combinedPath.shift();
    }
    if (isRequierdPoints(combinedPath[0], agentGroup)) {
      waiting = true; // Set waiting flag
      await new Promise((resolve) => setTimeout(resolve, waitPeriodAtPoints));
      waiting = false; // Reset waiting flag
    }
  }

  // point is considered to be required if it is a bay point
  function isRequierdPoints(point, agentGroup) {
    for (const nodeName of nodesToVisit) {
      const p = nodeMap.get(nodeName).point;
      if (p.x === point.x && p.y === point.y && p.z === point.z) {
        if (agentGroup.position.distanceTo(point) <= 0.1) {
          return true;
        }
      }
    }
    return false;
  }

  // Game loop
  const clock = new THREE.Clock();
  const delta = clock.getDelta();
  const gameLoop = () => {
    // Stopping the game loop when the button to which gameLoop is associated is not focused.
    if(!document.getElementById(pathButtonId).classList.contains("focused")){
      return;
    }

    move(clock.getDelta(), waitPeriodAtPoints);
    animateCircles(delta);
    controls.update();
    renderer.render(scene, camera);
    requestAnimationFrame(gameLoop);
  };
  gameLoop();
  console.warn(clock);
  return { combinedPath, checkpointCircles, pathLine, clock };
}
