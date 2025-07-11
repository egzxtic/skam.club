import WaterMark from './components/watermark.jsx'
import Zetka from './components/zetka.jsx'
import Hud from './components/hud.jsx'
import CarHud from './components/carhud.jsx'
import ProgressBar from './components/progresbar.jsx'
import Binds from './components/binds.jsx'
import Notify from './components/notify.jsx'
import RadioList from './components/radiolist.jsx'
import EasyGame from './components/minigierki/easygame.jsx'
import HelpNotify from './components/helpnotify.jsx'
import Dead from './components/dead.jsx'
import Garaz from './components/garaz.jsx'
import Settings from './components/settings.jsx'
import { Chat } from './components/chat.jsx'
 


export default function App() {

  return (
    <>
    <Zetka />
    <WaterMark />
    <Hud />
    <CarHud />  
    <EasyGame />
    <Garaz />
    <HelpNotify />
    <Settings />
    <ProgressBar />
    <Notify />
    <Binds />
    <RadioList />
    <Chat />
    <Dead />
    </>
  )
}