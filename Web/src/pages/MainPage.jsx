import { useRef } from "react";
import { Map, MapMarker, MarkerClusterer, CustomOverlayMap } from "react-kakao-maps-sdk";
import CLUSTERSET from "../constants/MapInfo";
import styled from 'styled-components';

export default function Cluster() {
  const geolocation = {
    lat: 37.510084581542465,
    lng: 127.0362614092063,
  };

  const mapRef = useRef();

  const onClusterclick = (_target, cluster) => {
    const map = mapRef.current
    const level = map.getLevel() - 1;
    map.setLevel(level, {anchor: cluster.getCenter()});
  };

  return (
    <Map // 지도를 표시할 Container
      center={{
        lat: geolocation.lat || 35.8881703,
        lng: geolocation.lng || 128.6113467,
      }}
      style={{
        // 지도의 크기
        width: "100%",
        height: "95vh",
      }}
      level={9} // 지도의 확대 레벨
      ref={mapRef}
    >
      {/* {geolocation && <MapMarker 
        position={geolocation} 
        image={{
            src: "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png", // 마커이미지의 주소입니다
            size: {
              width: 32,
              height: 37,
            }, // 마커이미지의 크기입니다
            options: {
              offset: {
                x: 15,
                y: 37,
              }, // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
            },
          }}
      />} */}
      <MarkerClusterer
        averageCenter={true} // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
        minLevel={7} // 클러스터 할 최소 지도 레벨
        disableClickZoom={true} // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정한다
        onClusterclick={onClusterclick}
      >
        {CLUSTERSET.map((pos, idx) => (
            <div key={idx}>
                <MapMarker
                    image={{
                    src: "https://i.ibb.co/wwsd9Zx/mappin.png", // 마커이미지의 주소입니다
                    size: {
                        width: 30,
                        height: 40,
                    }, // 마커이미지의 크기입니다
                    options: {
                        offset: {
                        x: 30,
                        y: 40,
                        }, // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
                    },
                    }}  
                    position={{
                    lat: pos.location[1],
                    lng: pos.location[0],
                    }}
                />
                <CustomOverlayMap
                    position={{
                        lat: pos.location[1],
                        lng: pos.location[0],
                        }}
                    yAnchor={1}
                    >
                    <CustomOverlay>
                        <a
                        href="https://map.kakao.com/link/map/11394059"
                        target="_blank"
                        rel="noreferrer"
                        >
                        <span className="title">사고 영상</span>
                        </a>
                    </CustomOverlay>
                </CustomOverlayMap>
            </div>
        ))}
      </MarkerClusterer>
    </Map>
  );
}

const CustomOverlay = styled.div`
    position: relative;
    top: -45px;
    right: 15px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 5px;
    width: 60px;
    height: 20px;
    background-color: #fff;
    border-radius: 5px;
    box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.3);
    
    a{
        font-size: 12px;
        text-decoration: none;
        color: #000;
    }
`;