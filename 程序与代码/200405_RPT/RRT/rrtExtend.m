function [RRTree1,pathFound,extendFail] = rrtExtend(RRTree1,RRTree2,goal,stepsize,maxFailedAttempts,disTh,map)
pathFound=[]; %if path found, returns new node connecting the two trees, index of the nodes in the two trees connected
failedAttempts=0;
while failedAttempts <= maxFailedAttempts
    if rand < 0.5,
        sample = rand(1,2) .* size(map); % random sample
    else
        sample = goal;  % sample taken as goal to bias tree generation to goal
    end
     
    [A, I] = min( distanceCost(RRTree1(:,1:2),sample) ,[],1); % find the minimum value of each column
    closestNode = RRTree1(I(1),:);
     
    %% moving from qnearest an incremental distance in the direction of qrand
    theta = atan2((sample(1)-closestNode(1)),(sample(2)-closestNode(2)));  % direction to extend sample to produce new node
    newPoint = double(int32(closestNode(1:2) + stepsize * [sin(theta)  cos(theta)]));
    if ~checkPath(closestNode(1:2), newPoint, map) % if extension of closest node in tree to the new point is feasible
        failedAttempts = failedAttempts + 1;
        continue;
    end
     
    [A, I2] = min( distanceCost(RRTree2(:,1:2),newPoint) ,[],1); % find closest in the second tree
    if distanceCost(RRTree2(I2(1),1:2),newPoint) < disTh,        % if both trees are connected
        pathFound=[newPoint I(1) I2(1)];extendFail=false;break;
    end
    [A, I3] = min( distanceCost(RRTree1(:,1:2),newPoint) ,[],1); % check if new node is not already pre-existing in the tree
    if distanceCost(newPoint,RRTree1(I3(1),1:2)) < disTh, failedAttempts=failedAttempts+1;continue; end
    RRTree1 = [RRTree1;newPoint I(1)];extendFail=false;break; % add node
end