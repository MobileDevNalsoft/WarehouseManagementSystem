

export function initNodes(three){

    const THREE = three;
    class Node {
        constructor(name,point) {
            this.name = name;
            this.point = point;
            this.adjacent = [];
        }
    }
    let nodes=[];
    const aisleBayPoints = {
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
        4:{
        
          3: new THREE.Vector3(-69.2, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-69.2, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-69.2, 6.19, -110.13989544214405),
        },
        5:{
    
          3: new THREE.Vector3(-46.4, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-46.4, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-46.4, 6.19, -110.13989544214405),
        },
        6:{
          3: new THREE.Vector3(-23.6, 6.19, -123.48706235353588),
          2: new THREE.Vector3(-23.6, 6.19, -116.79030548346806),
          1: new THREE.Vector3(-23.6, 6.19, -110.13989544214405),
        }
      };
      let  intermediatePointsCircles =[];
      let intermediatePoints = {
      "a1" :new THREE.Vector3(-138.0, 6.19, -130.0),
       "a2" :new THREE.Vector3(-116.0, 6.19, -130.0),
       "a3" :new THREE.Vector3(-92.4, 6.19, -130.0),
       "a4" :new THREE.Vector3( -69.2, 6.19, -130.0),
       "a5" :new THREE.Vector3(-46.4, 6.19, -130.0),
       "a6" :new THREE.Vector3(-23.6, 6.19, -130.0),
    
       "b1" :new THREE.Vector3(-138.0, 6.19, -100.0),
       "b2" :new THREE.Vector3(-116.0, 6.19, -100.0),
       "b3" :new THREE.Vector3(-92.4, 6.19, -100.0),
       "b4" :new THREE.Vector3( -69.2, 6.19, -100.0),
       "b5" :new THREE.Vector3(-46.4, 6.19, -100.0),
       "b6" :new THREE.Vector3(-23.6, 6.19, -100.0),
      };
      
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

const adjacencyList = {
    "Node_1_1": ["Node_1_2", "Node_b1"],
    "Node_1_2": ["Node_1_1", "Node_1_3"],
    "Node_1_3": ["Node_1_2", "Node_a1"],
    "Node_2_1": ["Node_2_2", "Node_b2"],
    "Node_2_2": ["Node_2_1", "Node_2_3"],
    "Node_2_3": ["Node_2_2", "Node_a2"],
    "Node_3_1": ["Node_3_2", "Node_b3"],
    "Node_3_2": ["Node_3_1", "Node_3_3"],
    "Node_3_3": ["Node_3_2", "Node_a3"],
    "Node_4_1": ["Node_4_2", "Node_b4"],
    "Node_4_2": ["Node_4_1", "Node_4_3"],
    "Node_4_3": ["Node_4_2", "Node_a4"],
    "Node_5_1": ["Node_5_2", "Node_b5"],
    "Node_5_2": ["Node_5_1", "Node_5_3"],
    "Node_5_3": ["Node_5_2", "Node_a5"],
    "Node_6_1": ["Node_6_2", "Node_b6"],
    "Node_6_2": ["Node_6_1", "Node_6_3"],
    "Node_6_3": ["Node_6_2", "Node_a6"],
    "Node_a1":["Node_1_3","Node_a2"],
    "Node_a2":["Node_a1","Node_2_3","Node_a3"],
    "Node_a3":["Node_a2","Node_3_3","Node_a4"],
    "Node_a4":["Node_a3","Node_4_3","Node_a5"],
    "Node_a5":["Node_a4","Node_5_3","Node_a6"],
    "Node_a6":["Node_a5","Node_6_3"],
    "Node_b1":["Node_1_1","Node_b2"],
    "Node_b2":["Node_b1","Node_2_1","Node_b3"],
    "Node_b3":["Node_b2","Node_3_1","Node_b4"],
    "Node_b4":["Node_b3","Node_4_1","Node_b5"],
    "Node_b5":["Node_b4","Node_5_1","Node_b6"],
    "Node_b6":["Node_b5","Node_6_1"],
  };
  


const nodeMap = new Map(nodes.map((node) => [node.name, node]));

    
for (const [nodeName, adjacentNames] of Object.entries(adjacencyList)) {
    const node = nodeMap.get(nodeName);
    if (node) {
        node.adjacent = adjacentNames.map((adjName) => nodeMap.get(adjName));
    }
    else{
        console.error(`Node ${nodeName} is missing in nodeMap.`);
    }
  }
  return {nodeMap,nodes,aisleBayPoints}

}







// export function initNavPathNodes(){


//   // Agent setup
//   const agentHeight = 3.0;
//   const agentRadius = 5.25;
//   agent = new THREE.Mesh(
//     new THREE.BoxGeometry(agentHeight, agentHeight, agentHeight),
//     new THREE.MeshPhongMaterial({ color: "green" })
//   );
//   agent.position.y = agentHeight / 2;
//    agentGroup = new THREE.Group();
//   agentGroup.add(agent);
//   // agentGroup.position.set(-95.1758, 6.0069, -102.0932);
//   scene.add(agentGroup);
//   let pathLine = null;
//   // Initial point and random checkpoints


 
// }

export function getShortestPath(bins,nodeMap,nodes,aisleBayPoints,three,scene,camera,controls,agentGroup,renderer){
    const THREE=three;
    let finalPath=[];
    let checkpointCircles=[];
    let combinedPath=[];
    let arrows=[];
    let pathLine = null;

    let animationId;
        
const checkpoints = setupCheckpoints(bins);
  
  const nodesToVisit =   findNodeNamesForPoints(checkpoints,nodes);
  console.warn("nodesToVisit",nodesToVisit)
  const { distMatrix, pathMatrix } = computeDistanceMatrix(nodesToVisit, nodeMap);
  const { minDist, path } = findShortestPath(nodesToVisit, distMatrix, pathMatrix);
  console.warn("Shortest Path Distance:", minDist,path,pathMatrix);
  
  
  for(let i=0;i<path.length-1;i++){
    let start = path[i];
    let end=path[i+1];
   finalPath=[...finalPath,...pathMatrix[start][end]];
  }
  
  visualizePath(finalPath.map((name)=>nodeMap.get(name).point))
  console.warn(finalPath);
  
  if(finalPath!=[]){
  createBlinkingCircles(nodesToVisit.map((name)=>nodeMap.get(name).point));
  combinedPath=[nodeMap.get(finalPath[0]).point];
  let start = finalPath[0];
  for(let i=1;i<finalPath.length;i++){
    if(start!=finalPath[i]){
      combinedPath.push(nodeMap.get(finalPath[i]).point);
    } 
  }
  scene.add(agentGroup);
  agentGroup.position.set(combinedPath[0].x, combinedPath[0].y, combinedPath[0].z);
  
  }
    function findNodeNamesForPoints(randomPoints, nodes) {
        return randomPoints.map(point => {
            return nodes.find(node => 
                node.point.x === point.x &&
                node.point.y === point.y &&
                node.point.z === point.z
            ).name;
        });
      }
      
      function bfs(startNode, targetNode, nodeMap) {
          const queue = [[startNode, [startNode.name]]]; // [currentNode, path] (path is an array of node names)
          const visited = new Set();
        
          while (queue.length > 0) {
              const [currentNode, path] = queue.shift(); // path will track the traversal sequence
        
              if (currentNode === targetNode) return { distance: path.length - 1, path }; // Return distance and the path
        
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
        
        
        function computeDistanceMatrix(nodesToVisit, nodeMap) {
          const distMatrix = {};
          const pathMatrix = {}; // To store paths
        
          nodesToVisit.forEach((nodeName) => {
              distMatrix[nodeName] = {};
              pathMatrix[nodeName] = {}; // Initialize path for each node
              nodesToVisit.forEach((otherNodeName) => {
                  if (nodeName !== otherNodeName) {
                      const { distance, path } = bfs(nodeMap.get(nodeName), nodeMap.get(otherNodeName), nodeMap);
                      distMatrix[nodeName][otherNodeName] = distance;
                      pathMatrix[nodeName][otherNodeName] = path;
                  }
                   else {
                      distMatrix[nodeName][otherNodeName] = 0; // Distance to itself
                      pathMatrix[nodeName][otherNodeName] = [nodeName]; // Path is just itself
                  }
              });
          });
        
          return { distMatrix, pathMatrix };
        }
        
        function findShortestPath(nodesToVisit, distMatrix, pathMatrix) {
          const n = nodesToVisit.length;
          const dp = Array(1 << n).fill(null).map(() => Array(n).fill(Infinity));
          const parent = Array(1 << n).fill(null).map(() => Array(n).fill(-1));
          const nodeIndex = nodesToVisit.reduce((map, name, index) => {
              map[name] = index;
              return map;
          }, {});
        
          dp[1][0] = 0; // Start at the first node (Node_1_1)
        
          for (let mask = 1; mask < (1 << n); mask++) {
              for (let u = 0; u < n; u++) {
                  if (!(mask & (1 << u))) continue; // Skip if `u` is not in the current mask
        
                  for (let v = 0; v < n; v++) {
                      if (u === v || !(mask & (1 << v))) continue; // Skip if `v` is not in the mask or same as `u`
                      const prevMask = mask ^ (1 << u); // Remove `u` from the current mask
                      const cost = dp[prevMask][v] + distMatrix[nodesToVisit[v]][nodesToVisit[u]];
        
                      if (cost < dp[mask][u]) {
                          dp[mask][u] = cost;
                          parent[mask][u] = v; // Track parent for reconstruction
                      }
                  }
              }
          }
        
          // Find the end node with the minimum cost
          let minDist = Infinity;
          let lastNode = -1;
          for (let u = 0; u < n; u++) {
              if (dp[(1 << n) - 1][u] < minDist) {
                  minDist = dp[(1 << n) - 1][u];
                  lastNode = u;
              }
          }
        
          // Reconstruct the path
          const finalPath = [];
          let mask = (1 << n) - 1;
          while (lastNode !== -1) {
              finalPath.unshift(nodesToVisit[lastNode]);
              const prevNode = parent[mask][lastNode];
              mask ^= 1 << lastNode; // Remove the last node from the mask
              lastNode = prevNode;
          }
        
          return { minDist, path: finalPath };
        }
      
        function setupCheckpoints(binNames) {
      
          let binPoints = [];
        
          for (let index in binNames) {
            const aisle = parseInt(binNames[index]); // Convert first character (aisle number) to an integer
            const bay = binNames[index][3]; // Extract the bay number from the bin
            const direction = binNames[index][1]; // Extract the direction ("R" or "L")
        
            // Handle right (R) or left (L) adjustment warnic if necessary
            const adjustedAisle = direction === "R" ? aisle + 1 : aisle; // Adjust if required
        
            // Get the corresponding Vector3 point
            const point = aisleBayPoints[adjustedAisle.toString()]?.[bay];
            if (!point) {
              console.warn(`No point found for bin: ${bin}`);
              return null;
            }
            if (!binPoints.includes(point)) {
              binPoints.push(point);
            }
          }
        
          // Filter out any null points and warn the binPoints
          const validBinPoints = binPoints.filter((point) => point !== null);
          console.warn("Valid bin points:", validBinPoints);
        
          return validBinPoints;
        }
      
        function createBlinkingCircles(points) {
          // Clear existing circles
        //   checkpointCircles.forEach((circle) => scene.remove(circle));
        //   checkpointCircles.length = 0;
        checkpointCircles=[];
          const circleMaterial = new THREE.MeshBasicMaterial({
            color: 0xffff00, // Yellow
            side: THREE.DoubleSide,
            transparent: true,
            opacity: 0.8, // Start opacity
          });
      
          points.forEach((point) => {
            const circleGeometry = new THREE.CircleGeometry(1, 32); // Radius 2, 32 segments
            const circle = new THREE.Mesh(circleGeometry, circleMaterial);
      
            // Rotate to lie flat on the ground
            circle.rotation.x = -Math.PI / 2;
      
            // Position at the checkpoint
            circle.position.set(point.x, point.y + 0.1, point.z); // Slightly above ground
            scene.add(circle);
            checkpointCircles.push(circle);
          });
        }
      
        // Function to visualize the path
        function visualizePath(path) {
      
          const lineGeometry = new THREE.BufferGeometry().setFromPoints(path);
          const lineMaterial = new THREE.LineDashedMaterial({
            color: 0xff0000,
            dashSize: 0.5,
            gapSize: 0.5,
          });
      
          pathLine = new THREE.Line(lineGeometry, lineMaterial);
          scene.add(pathLine);
        }
      
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
        function drawArrowsForPath(path) {
          // Remove existing arrows
          arrows.forEach((arrow) => scene.remove(arrow));
          arrows.length = 0;
      
          // Iterate through the path to create arrows
          for (let i = 0; i < path.length - 1; i++) {
            const start = path[i].clone(); // Use cloned objects
            const end = path[i + 1].clone();
      
            // Calculate the direction vector
            const dir = new THREE.Vector3().subVectors(end, start).normalize();
      
            // Length of the arrow
            const length = start.distanceTo(end);
      
            // Create the arrow
            const arrow = new THREE.ArrowHelper(dir, start, length, 0xff0000, 2.5, 1); // Red arrow
            scene.add(arrow);
            arrows.push(arrow);
          }
        }
   

  // function animateCircles(delta) {
  //   const time = clock.getElapsedTime();

  //   checkpointCircles.forEach((circle, index) => {
  //     // Scale the circle up and down
  //     const scale = 1 + 0.2 * Math.sin(time * 2); // Adjust frequency with time multiplier
  //     circle.scale.set(scale, scale, scale);

  //     // Optionally adjust opacity for a fading effect
  //     circle.material.opacity = 0.5 + 0.5 * Math.sin(time * 2);
  //   });
  // }

function move(delta) {
  let SPEED=5;
  if (!combinedPath || combinedPath.length <= 0) {
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
      currentAngle += angleDifference * delta * 5; // Smoothly interpolate rotation
      agentGroup.rotation.y = currentAngle;

    }
    const moveDistance = Math.min(delta * SPEED, Math.sqrt(distanceSq));
    agentGroup.position.add(direction.multiplyScalar(moveDistance));
  } else {
    agentGroup.position.copy(targetPosition);
    combinedPath.shift();
  }
}


// Game loop
const clock = new THREE.Clock();
const delta = clock.getDelta();
const gameLoop = () => {
 move(clock.getDelta());
 animateCircles(delta);
 controls.update();
 renderer.render(scene, camera);
//  requestAnimationFrame(gameLoop);
requestAnimationFrame(gameLoop);
};
gameLoop();   
      console.warn(clock);
       return {combinedPath,checkpointCircles,pathLine,clock}
      
}



